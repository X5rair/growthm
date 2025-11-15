import type {
  GoalInput,
  SkillTreeDraft,
  SkillTreeNodeDraft,
  SprintPlan,
  SprintTaskDraft,
} from "./types.ts";

const CHAT_URL = "https://api.openai.com/v1/chat/completions";
const MODEL = "gpt-4.1";

async function callLLM(prompt: string): Promise<string> {
  const apiKey = Deno.env.get("OPENAI_API_KEY");
  if (!apiKey) {
    throw new Error("OPENAI_API_KEY is not configured for LLM calls");
  }

  const response = await fetch(CHAT_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${apiKey}`,
    },
    body: JSON.stringify({
      model: MODEL,
      messages: [
        {
          role: "system",
          content:
            "You are a growth architect for a personal development product.",
        },
        { role: "user", content: prompt },
      ],
      temperature: 0.3,
    }),
  });

  if (!response.ok) {
    const text = await response.text();
    throw new Error(`LLM call failed with ${response.status}: ${text}`);
  }

  const payload = await response.json();
  const choice = payload?.choices?.[0]?.message?.content;
  if (!choice) {
    throw new Error("LLM response did not contain a completion");
  }

  return choice;
}

function formatNodeValue(value: string): string {
  return value.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(
    /^-+|-+$/g,
    "",
  );
}

function buildFallbackNodes(input: GoalInput): SkillTreeNodeDraft[] {
  const base = formatNodeValue(input.title);
  const focus = Math.max(3, Math.round(input.horizonMonths * 4));
  const nodes: SkillTreeNodeDraft[] = [
    {
      nodePath: `${base}.clarify`,
      title: `Clarify the vision for ${input.title}`,
      level: 1,
      focusHours: focus,
      payload: { example: "define success criteria" },
    },
    {
      nodePath: `${base}.practices`,
      title: "Build foundational practice habits",
      level: 1,
      focusHours: Math.max(2, Math.round(focus * 0.8)),
      payload: { example: "daily review, spaced repetition" },
    },
    {
      nodePath: `${base}.feedback`,
      title: "Capture signals and feedback",
      level: 2,
      focusHours: Math.max(1, Math.round(focus * 0.6)),
      payload: { example: "weekly reflection" },
    },
  ];
  return nodes;
}

function heuristicSprintSummary(input: GoalInput): string {
  return `Sprint 1 for "${input.title}" focuses on clarifying intent and kickstarting practice.`;
}

function buildSprintTasks(
  nodes: SkillTreeNodeDraft[],
  baseDate: Date,
): SprintTaskDraft[] {
  return nodes.slice(0, 4).map((node, index) => {
    const due = new Date(baseDate);
    due.setDate(baseDate.getDate() + index * 2 + 3);
    const difficulty = node.focusHours > 20
      ? "high"
      : node.focusHours > 10
      ? "medium"
      : "low";
    return {
      title: node.title,
      description: `Work on ${node.title} by allocating ${
        Math.ceil(node.focusHours)
      } focused minutes this week.`,
      difficulty,
      dueDate: due.toISOString().split("T")[0],
      estimatedMinutes: Math.max(15, Math.round(node.focusHours)),
      nodePath: node.nodePath,
    };
  });
}

function buildTreeJson(
  input: GoalInput,
  nodes: SkillTreeNodeDraft[],
): Record<string, unknown> {
  return {
    title: input.title,
    description: input.description,
    horizonMonths: input.horizonMonths,
    createdBy: "system",
    nodes: nodes.map((node) => ({
      path: node.nodePath,
      title: node.title,
      level: node.level,
      focusHours: node.focusHours,
      payload: node.payload,
    })),
  };
}

export async function generateSkillTreeDraft(
  input: GoalInput,
): Promise<SkillTreeDraft> {
  const nodes = buildFallbackNodes(input);

  if (Deno.env.get("OPENAI_API_KEY")) {
    try {
      const prompt =
        `Create 3 skill-tree nodes for the goal titled \"${input.title}\". Output valid JSON like {"nodes": [{"nodePath":"...","title":"...","level":1,"focusHours":10,"payload":{}}]}.`;
      const raw = await callLLM(prompt);
      const parsed = JSON.parse(raw);
      if (Array.isArray(parsed.nodes) && parsed.nodes.length > 0) {
        return {
          treeJson: buildTreeJson(input, parsed.nodes),
          nodes: parsed.nodes,
        };
      }
    } catch (error) {
      console.warn("LLM fallback used because:", error);
    }
  }

  return {
    treeJson: buildTreeJson(input, nodes),
    nodes,
  };
}

function formatDate(date: Date): string {
  return date.toISOString().split("T")[0];
}

export function planInitialSprint(
  input: GoalInput,
  nodes: SkillTreeNodeDraft[],
): SprintPlan {
  const today = new Date();
  const end = new Date(today);
  end.setDate(today.getDate() + 6);

  return {
    sprintNumber: 1,
    fromDate: formatDate(today),
    toDate: formatDate(end),
    summary: heuristicSprintSummary(input),
    tasks: buildSprintTasks(nodes, today),
  };
}
