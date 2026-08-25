import { ToolDefinition } from "../types";

interface CreateTaskInput {
  title: string;
  dueDate?: string;
}

interface CreatedTask {
  id: string;
  title: string;
  dueDate?: string;
}

/**
 * Creates a task. Marked as requiring confirmation because it writes new
 * data that the user did not directly type themselves — PANTHER must
 * confirm before committing it.
 */
export const taskTool: ToolDefinition<CreateTaskInput, CreatedTask> = {
  name: "task.create",
  description: "Create a task/to-do item.",
  requiresConfirmation: true,
  validate(input) {
    const candidate = input as Record<string, unknown>;
    if (typeof candidate?.title !== "string" || candidate.title.trim().length === 0) {
      return { ok: false, error: "'title' must be a non-empty string." };
    }
    if (candidate.dueDate !== undefined && typeof candidate.dueDate !== "string") {
      return { ok: false, error: "'dueDate' must be a string if provided." };
    }
    return { ok: true, input: { title: candidate.title, dueDate: candidate.dueDate as string | undefined } };
  },
  async execute(input) {
    return { id: crypto.randomUUID(), title: input.title, dueDate: input.dueDate };
  },
};
