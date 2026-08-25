import { AIProvider, AIStreamChunk, TurnContext } from "../types";

const SYSTEM_PROMPT = `You are PANTHER, a calm, confident personal AI agent. Your philosophy is "Think Ahead."
Be concise and direct. Lead with the conclusion, not the caveats. Never pad answers with filler like
"here are some things you could consider" — state what matters, then support it briefly. You are not a
generic chatbot: you are observant, proactive, and never pretend to know something you don't. When the
user asks you to remember something, or to act on an external service, say so plainly rather than
performing the action silently.`;

/**
 * Real provider backed by the Anthropic Messages API, used automatically
 * once ANTHROPIC_API_KEY is present. Kept dependency-light (raw fetch to the
 * streaming endpoint) so the app doesn't require the SDK just to boot in
 * demo mode.
 */
class AnthropicProvider implements AIProvider {
  readonly id = "anthropic";

  get isConfigured(): boolean {
    return Boolean(process.env.ANTHROPIC_API_KEY);
  }

  async *streamCompletion(context: TurnContext): AsyncGenerator<AIStreamChunk> {
    const apiKey = process.env.ANTHROPIC_API_KEY;
    if (!apiKey) {
      yield { type: "error", error: "ANTHROPIC_API_KEY is not configured." };
      return;
    }

    const memoryBlock =
      context.items.length > 0
        ? `Relevant context:\n${context.items.map((i) => `- (${i.label}) ${i.content}`).join("\n")}\n\n`
        : "";

    const messages = context.conversation
      .filter((m) => m.role === "user" || m.role === "assistant")
      .map((m) => ({ role: m.role, content: m.content }));

    if (messages.length > 0) {
      messages[messages.length - 1] = {
        ...messages[messages.length - 1],
        content: memoryBlock + messages[messages.length - 1].content,
      };
    }

    const response = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "content-type": "application/json",
        "x-api-key": apiKey,
        "anthropic-version": "2023-06-01",
      },
      body: JSON.stringify({
        model: process.env.ANTHROPIC_MODEL || "claude-3-5-haiku-latest",
        max_tokens: 1024,
        system: SYSTEM_PROMPT,
        messages,
        stream: true,
      }),
    });

    if (!response.ok || !response.body) {
      yield { type: "error", error: `AI provider request failed (${response.status}).` };
      return;
    }

    const reader = response.body.getReader();
    const decoder = new TextDecoder();
    let buffer = "";

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;
      buffer += decoder.decode(value, { stream: true });

      const lines = buffer.split("\n");
      buffer = lines.pop() ?? "";

      for (const line of lines) {
        if (!line.startsWith("data:")) continue;
        const payload = line.slice(5).trim();
        if (!payload || payload === "[DONE]") continue;
        try {
          const event = JSON.parse(payload);
          if (event.type === "content_block_delta" && event.delta?.text) {
            yield { type: "text", delta: event.delta.text as string };
          }
        } catch {
          // Ignore malformed SSE fragments rather than crashing the stream.
        }
      }
    }

    yield { type: "done" };
  }
}

export const anthropicProvider: AIProvider = new AnthropicProvider();
