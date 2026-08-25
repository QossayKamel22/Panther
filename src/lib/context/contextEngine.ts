import { memoryStore } from "@/lib/memory/inMemoryStore";
import { ChatMessage, ContextItem, TurnContext } from "@/lib/ai/types";

const MAX_CONVERSATION_TURNS = 20;
const MAX_MEMORY_ITEMS = 6;

/**
 * Assembles what the AI Orchestrator needs for one turn: recent
 * conversation (short-term memory) plus relevant long-term memory entries.
 * This is the single seam where future context sources (calendar, email,
 * documents) plug in without touching the orchestrator itself.
 */
export async function buildTurnContext(
  conversation: ChatMessage[],
  latestUserMessage: string
): Promise<TurnContext> {
  const recentConversation = conversation.slice(-MAX_CONVERSATION_TURNS);

  const relevantMemory = await memoryStore.search(latestUserMessage);
  const allMemory = relevantMemory.length > 0 ? relevantMemory : await memoryStore.list();

  const items: ContextItem[] = allMemory.slice(0, MAX_MEMORY_ITEMS).map((entry) => ({
    id: entry.id,
    source: "memory",
    label: entry.scope,
    content: entry.content,
  }));

  return { conversation: recentConversation, items };
}
