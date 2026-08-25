/**
 * Modular tool contract. Every capability PANTHER can invoke (calendar,
 * email, tasks, search, memory, documents, ...) implements this shape so the
 * Tool Router can validate, gate, and execute them uniformly.
 */
export interface ToolDefinition<TInput = unknown, TOutput = unknown> {
  name: string;
  description: string;
  /** True if executing this tool can affect the user's external accounts/data. */
  requiresConfirmation: boolean;
  validate(input: unknown): { ok: true; input: TInput } | { ok: false; error: string };
  execute(input: TInput): Promise<TOutput>;
}

export interface ToolExecutionResult {
  tool: string;
  ok: boolean;
  output?: unknown;
  error?: string;
}
