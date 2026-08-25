import { buildTurnContext } from "@/lib/context/contextEngine";
import { AIStreamChunk, ChatMessage } from "./types";
import { demoProvider } from "./providers/demoProvider";
import { anthropicProvider } from "./providers/anthropicProvider";

/**
 * AI Orchestrator: the single entry point the interface talks to. It never
 * touches the UI, memory storage, or tool implementations directly — it
 * pulls context from the Context Engine and delegates generation to
 * whichever provider is configured, falling back to the demo provider so
 * the product is never visibly broken.
 */
export async function* orchestrateTurn(
  conversation: ChatMessage[],
  latestUserMessage: string
): AsyncGenerator<AIStreamChunk> {
  const context = await buildTurnContext(conversation, latestUserMessage);
  const provider = anthropicProvider.isConfigured ? anthropicProvider : demoProvider;

  yield* provider.streamCompletion(context);
}

export function activeProviderId(): string {
  return anthropicProvider.isConfigured ? anthropicProvider.id : demoProvider.id;
}
