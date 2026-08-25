import { ToolDefinition, ToolExecutionResult } from "./types";
import { calendarTool } from "./tools/calendarTool";
import { taskTool } from "./tools/taskTool";
import { memoryTool } from "./tools/memoryTool";
import { searchTool } from "./tools/searchTool";

/**
 * Central registry + dispatcher for every tool PANTHER can call. Nothing
 * outside this module needs to know how an individual tool is implemented —
 * it only needs a tool name and an input payload.
 */
const registry = new Map<string, ToolDefinition>([
  [calendarTool.name, calendarTool as ToolDefinition],
  [taskTool.name, taskTool as ToolDefinition],
  [memoryTool.name, memoryTool as ToolDefinition],
  [searchTool.name, searchTool as ToolDefinition],
]);

export function listTools(): ToolDefinition[] {
  return Array.from(registry.values());
}

export function getTool(name: string): ToolDefinition | undefined {
  return registry.get(name);
}

/**
 * Validates and (if allowed) executes a tool call. Confirmation-gated tools
 * are never executed here without `confirmed: true` — the caller is
 * responsible for surfacing the confirmation step to the user first.
 */
export async function runTool(
  name: string,
  input: unknown,
  options: { confirmed?: boolean } = {}
): Promise<ToolExecutionResult> {
  const tool = getTool(name);
  if (!tool) {
    return { tool: name, ok: false, error: `Unknown tool: ${name}` };
  }

  const validation = tool.validate(input);
  if (!validation.ok) {
    return { tool: name, ok: false, error: validation.error };
  }

  if (tool.requiresConfirmation && !options.confirmed) {
    return {
      tool: name,
      ok: false,
      error: "This action requires explicit user confirmation before it can run.",
    };
  }

  try {
    const output = await tool.execute(validation.input);
    return { tool: name, ok: true, output };
  } catch (err) {
    return { tool: name, ok: false, error: err instanceof Error ? err.message : "Tool execution failed." };
  }
}
