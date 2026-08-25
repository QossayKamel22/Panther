/**
 * Core types shared across the PANTHER intelligence stack.
 *
 * Layering (see docs/ARCHITECTURE.md):
 *   Interface -> AI Orchestrator -> Context Engine -> Memory -> Tool Router -> Services
 */

export type MessageRole = "user" | "assistant" | "system" | "tool";

export interface ChatMessage {
  id: string;
  role: MessageRole;
  content: string;
  createdAt: number;
  /** Present when the assistant used a tool to produce this message. */
  toolCalls?: ToolCall[];
}

export interface ToolCall {
  id: string;
  tool: string;
  input: unknown;
  output?: unknown;
  status: "pending" | "confirmed" | "denied" | "completed" | "error";
  requiresConfirmation: boolean;
}

/** A single retrievable fact assembled by the Context Engine for one turn. */
export interface ContextItem {
  id: string;
  source: "memory" | "conversation" | "tool";
  label: string;
  content: string;
}

/** The full context bundle handed to the AI Orchestrator for a turn. */
export interface TurnContext {
  conversation: ChatMessage[];
  items: ContextItem[];
}

export interface AIStreamChunk {
  type: "text" | "tool_call" | "done" | "error";
  delta?: string;
  toolCall?: ToolCall;
  error?: string;
}

/** Implemented by any AI provider (demo, OpenAI, Anthropic, ...). */
export interface AIProvider {
  readonly id: string;
  readonly isConfigured: boolean;
  streamCompletion(context: TurnContext): AsyncGenerator<AIStreamChunk>;
}
