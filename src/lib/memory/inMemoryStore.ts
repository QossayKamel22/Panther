import { MemoryEntry, MemoryStore } from "./types";

/**
 * Development/demo memory store. Backed by a process-local array so the
 * product works end to end without a database configured.
 *
 * Swap for a persisted implementation (e.g. Postgres/Firestore) behind the
 * same MemoryStore interface — nothing above this layer needs to change.
 */
export class InMemoryMemoryStore implements MemoryStore {
  private entries: MemoryEntry[] = [];
  private sequence = 0;
  private order = new Map<string, number>();

  async list(): Promise<MemoryEntry[]> {
    return [...this.entries].sort(
      (a, b) => b.createdAt - a.createdAt || (this.order.get(b.id)! - this.order.get(a.id)!)
    );
  }

  async add(entry: Omit<MemoryEntry, "id" | "createdAt">): Promise<MemoryEntry> {
    const created: MemoryEntry = {
      ...entry,
      id: crypto.randomUUID(),
      createdAt: Date.now(),
    };
    this.order.set(created.id, this.sequence++);
    this.entries.push(created);
    return created;
  }

  async remove(id: string): Promise<void> {
    this.entries = this.entries.filter((e) => e.id !== id);
    this.order.delete(id);
  }

  async search(query: string): Promise<MemoryEntry[]> {
    const q = query.toLowerCase();
    return this.entries.filter((e) => e.content.toLowerCase().includes(q));
  }
}

function createSeededStore(): MemoryStore {
  const store = new InMemoryMemoryStore();
  void store.add({
    scope: "instruction",
    content: "Keep answers short and direct. Lead with the conclusion.",
    source: "user_explicit",
  });
  return store;
}

// Singleton for the lifetime of the server process (demo mode only).
export const memoryStore: MemoryStore = createSeededStore();
