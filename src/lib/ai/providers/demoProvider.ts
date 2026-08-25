import { AIProvider, AIStreamChunk, TurnContext } from "../types";

const PANTHER_VOICE_NOTE =
  "(Demo mode — no AI provider is configured. Set ANTHROPIC_API_KEY to enable real reasoning.)";

/**
 * Deterministic, dependency-free provider used when no real AI API key is
 * configured. Guarantees the product never looks broken in development —
 * it streams a clearly-labeled, on-brand response instead of failing.
 */
class DemoProvider implements AIProvider {
  readonly id = "demo";
  readonly isConfigured = true;

  async *streamCompletion(context: TurnContext): AsyncGenerator<AIStreamChunk> {
    const lastUserMessage = [...context.conversation].reverse().find((m) => m.role === "user");
    const text = composeReply(lastUserMessage?.content ?? "", context);

    // Stream word-by-word so the UI exercises the same streaming path a
    // real provider would use.
    const words = text.split(" ");
    for (const word of words) {
      yield { type: "text", delta: word + " " };
      await sleep(18);
    }
    yield { type: "done" };
  }
}

function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function composeReply(userText: string, context: TurnContext): string {
  const lower = userText.toLowerCase();
  const memoryNote =
    context.items.length > 0
      ? ` I'm keeping ${context.items.length} thing${context.items.length === 1 ? "" : "s"} from memory in mind.`
      : "";

  if (/what.*(matter|focus|priorit)/.test(lower)) {
    return `You have three things worth attention today. The first is time-sensitive — I'd handle it before your next meeting. ${PANTHER_VOICE_NOTE}${memoryNote}`;
  }
  if (/prepare|meeting/.test(lower)) {
    return `Here's what I'd walk in knowing: the agenda, the last decision made on this topic, and one open question worth raising. ${PANTHER_VOICE_NOTE}${memoryNote}`;
  }
  if (/remember/.test(lower)) {
    return `Got it — I've saved that. I'll bring it back up when it's relevant. ${PANTHER_VOICE_NOTE}`;
  }
  if (userText.trim().length === 0) {
    return `I'm here. Ask me what matters today, or tell me something to remember. ${PANTHER_VOICE_NOTE}`;
  }
  return `Understood. Here's my read: this is straightforward, and I'd move on it directly rather than overthink it. ${PANTHER_VOICE_NOTE}${memoryNote}`;
}

export const demoProvider: AIProvider = new DemoProvider();
