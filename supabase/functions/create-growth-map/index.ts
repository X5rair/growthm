import { serve } from "https://deno.land/std@0.214.0/http/server.ts";
import { supabaseAdmin } from "../_shared/supabaseAdmin.ts";
import { ApiError, errorHandler } from "../_shared/errorHandler.ts";
import {
  generateSkillTreeDraft,
  planInitialSprint,
} from "../_shared/llmClient.ts";
import {
  extractBearerToken,
  requireAuthenticatedUser,
} from "../_shared/auth.ts";
import type {
  CreateGrowthMapBody,
  CreateGrowthMapResult,
  SkillTreeNodeDraft,
  SkillTreeNodeRecord,
  SprintTaskDraft,
} from "../_shared/types.ts";

serve(async (req) => {
  try {
    if (req.method !== "POST") {
      return new Response(null, { status: 405, headers: { Allow: "POST" } });
    }

    const token = extractBearerToken(req);
    const user = await requireAuthenticatedUser(token);

    const payload = (await req.json()) as CreateGrowthMapBody;
    validateGoalInput(payload);

    const { data: goal, error: goalError } = await supabaseAdmin
      .from("goals")
      .insert([
        {
          user_id: user.id,
          title: payload.title,
          description: payload.description,
          horizon_months: payload.horizonMonths,
          daily_minutes: payload.dailyMinutes,
          status: "active",
          priority: 0,
          target_date: payload.targetDate ?? null,
        },
      ])
      .select("*")
      .single();

    if (goalError || !goal) {
      throw new ApiError("Failed to insert goal", 500);
    }

    const draft = await generateSkillTreeDraft(payload);

    const { data: tree, error: treeError } = await supabaseAdmin
      .from("skill_trees")
      .insert([
        {
          goal_id: goal.id,
          tree_json: draft.treeJson,
          generated_by: "create-growth-map",
          version: 1,
        },
      ])
      .select("*")
      .single();

    if (treeError || !tree) {
      throw new ApiError("Failed to persist skill tree", 500);
    }

    const nodePayloads = draft.nodes.map((node) => (
      {
        skill_tree_id: tree.id,
        node_path: node.nodePath,
        title: node.title,
        level: node.level,
        focus_hours: node.focusHours,
        payload: node.payload,
      }
    ));

    const { data: insertedNodes, error: nodeError } = await supabaseAdmin
      .from("skill_tree_nodes")
      .insert(nodePayloads)
      .select("*");

    if (nodeError || !insertedNodes) {
      throw new ApiError("Failed to persist skill tree nodes", 500);
    }

    const sprintPlan = planInitialSprint(payload, draft.nodes);

    const { data: sprint, error: sprintError } = await supabaseAdmin
      .from("sprints")
      .insert([
        {
          goal_id: goal.id,
          sprint_number: sprintPlan.sprintNumber,
          from_date: sprintPlan.fromDate,
          to_date: sprintPlan.toDate,
          status: "planned",
          summary: sprintPlan.summary,
          metrics: { horizonMonths: payload.horizonMonths },
        },
      ])
      .select("*")
      .single();

    if (sprintError || !sprint) {
      throw new ApiError("Failed to persist sprint", 500);
    }

    const nodeMap = new Map<string, SkillTreeNodeRecord>();
    insertedNodes.forEach((node) => nodeMap.set(node.node_path, node));

    const taskPayloads = buildTaskPayloads(
      sprintPlan.tasks,
      sprint.id,
      nodeMap,
    );
    const { data: insertedTasks, error: tasksError } = await supabaseAdmin
      .from("sprint_tasks")
      .insert(taskPayloads)
      .select("*");

    if (tasksError || !insertedTasks) {
      throw new ApiError("Failed to persist sprint tasks", 500);
    }

    const response: CreateGrowthMapResult = {
      goal,
      skillTree: { ...tree, nodes: insertedNodes },
      sprint: { ...sprint, tasks: insertedTasks },
    };

    return new Response(JSON.stringify(response), {
      status: 201,
      headers: { "Content-Type": "application/json" },
    });
  } catch (error) {
    return errorHandler(error);
  }
});

function buildTaskPayloads(
  tasks: SprintTaskDraft[],
  sprintId: string,
  nodeMap: Map<string, SkillTreeNodeRecord>,
) {
  return tasks.map((task) => ({
    sprint_id: sprintId,
    skill_node_id: task.nodePath
      ? nodeMap.get(task.nodePath)?.id ?? null
      : null,
    title: task.title,
    description: task.description,
    difficulty: task.difficulty,
    status: "pending",
    due_date: task.dueDate ?? null,
    estimated_minutes: task.estimatedMinutes ?? null,
  }));
}

function validateGoalInput(payload: CreateGrowthMapBody) {
  if (!payload.title?.trim() || !payload.description?.trim()) {
    throw new ApiError("Goal title and description are required", 400);
  }
  if (!Number.isFinite(payload.horizonMonths) || payload.horizonMonths <= 0) {
    throw new ApiError("horizonMonths must be a positive number", 400);
  }
  if (!Number.isFinite(payload.dailyMinutes) || payload.dailyMinutes <= 0) {
    throw new ApiError("dailyMinutes must be a positive number", 400);
  }
}
