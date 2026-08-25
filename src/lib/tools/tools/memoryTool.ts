import { memoryStore } from "@/lib/memory/inMemoryStore";
import { MemoryScope } from "@/lib/memory/types";
import { ToolDefinition } from "../types";

interface RememberInput {
  content: string;
  scope?: MemoryScope;
}

const VALID_SCOPES: MemoryScope[] = ["preference", "project", "decision", "instruction", "fact"];

/**
 * Stores an explicit fact/preference/decision the user asked PANTHER to
 * remember. Never invoked silently — only in response to an explicit
 * "remember this" style instruction from the user.
 */
export const memoryTool: ToolDefinition<RememberInput, { id: string }> = {
  name: "memory.remember",
  description: "Save an explicit fact, preference, or decision to long-term memory.",
  requiresConfirmation: false,
  validate(input) {
    if (typeof input !== "object" || input === null) {
      return { ok: false, error: "Expected an object with a 'content' field." };
    }
    const candidate = input as Record<string, unknown>;
    if (typeof candidate.content !== "string" || candidate.content.trim().length === 0) {
      return { ok: false, error: "'content' must be a non-empty string." };
    }
    if (candidate.scope !== undefined && !VALID_SCOPES.includes(candidate.scope as MemoryScope)) {
      return { ok: false, error: `'scope' must be one of: ${VALID_SCOPES.join(", ")}` };
    }
    return {
      ok: true,
      input: { content: candidate.content, scope: candidate.scope as MemoryScope | undefined },
    };
  },
  async execute(input) {
    const entry = await memoryStore.add({
      content: input.content,
      scope: input.scope ?? "fact",
      source: "user_explicit",
    });
    return { id: entry.id };
  },
};
