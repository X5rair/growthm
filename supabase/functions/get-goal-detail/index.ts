import { serve } from "https://deno.land/std@0.214.0/http/server.ts";
import { supabaseAdmin } from "../_shared/supabaseAdmin.ts";
import { ApiError, errorHandler } from "../_shared/errorHandler.ts";
import {
  extractBearerToken,
  requireAuthenticatedUser,
} from "../_shared/auth.ts";
import type {
  GoalDetailResponse,
  SkillTreeNodeRecord,
} from "../_shared/types.ts";

serve(async (req) => {
  try {
    if (req.method !== "GET") {
      return new Response(null, { status: 405, headers: { Allow: "GET" } });
    }

    const token = extractBearerToken(req);
    const user = await requireAuthenticatedUser(token);

    const url = new URL(req.url);
    const goalId = url.searchParams.get("goal_id")?.trim();
    if (!goalId) {
      throw new ApiError("goal_id is required", 400);
    }

    const { data: goal, error: goalError } = await supabaseAdmin
      .from("goals")
      .select("*")
      .eq("id", goalId)
      .maybeSingle();

    if (goalError || !goal) {
      throw new ApiError("Goal not found", 404);
    }

    if (goal.user_id !== user.id) {
      throw new ApiError("Forbidden", 403);
    }

    const { data: skillTree, error: skillTreeError } = await supabaseAdmin
      .from("skill_trees")
      .select("*")
      .eq("goal_id", goalId)
      .maybeSingle();

    if (skillTreeError) {
      throw new ApiError("Failed to load skill tree", 500);
    }

    let nodes: SkillTreeNodeRecord[] = [];
    if (skillTree) {
      const { data: savedNodes, error: nodesError } = await supabaseAdmin
        .from("skill_tree_nodes")
        .select("*")
        .eq("skill_tree_id", skillTree.id);
      if (nodesError) {
        throw new ApiError("Failed to load skill tree nodes", 500);
      }
      nodes = savedNodes ?? [];
    }
    const { data: latestSprint, error: sprintError } = await supabaseAdmin
      .from("sprints")
      .select("*")
      .eq("goal_id", goalId)
      .order("sprint_number", { ascending: false })
      .limit(1)
      .maybeSingle();

    if (sprintError) {
      throw new ApiError("Failed to load sprint", 500);
    }

    let latestSprintWithTasks = null;
    if (latestSprint) {
      const { data: sprintTasks, error: tasksError } = await supabaseAdmin
        .from("sprint_tasks")
        .select("*")
        .eq("sprint_id", latestSprint.id);
      if (tasksError) {
        throw new ApiError("Failed to load sprint tasks", 500);
      }
      latestSprintWithTasks = { ...latestSprint, tasks: sprintTasks ?? [] };
    }

    const response: GoalDetailResponse = {
      goal,
      skillTree: skillTree
        ? {
          ...skillTree,
          nodes,
        }
        : null,
      latestSprint: latestSprintWithTasks,
    };

    return new Response(JSON.stringify(response), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (error) {
    return errorHandler(error);
  }
});
