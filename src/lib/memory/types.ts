export type MemoryScope = "preference" | "project" | "decision" | "instruction" | "fact";

export interface MemoryEntry {
  id: string;
  scope: MemoryScope;
  content: string;
  createdAt: number;
  /** Memory is explicit and controllable: nothing is stored without this. */
  source: "user_explicit" | "user_confirmed";
}

export interface MemoryStore {
  list(): Promise<MemoryEntry[]>;
  add(entry: Omit<MemoryEntry, "id" | "createdAt">): Promise<MemoryEntry>;
  remove(id: string): Promise<void>;
  search(query: string): Promise<MemoryEntry[]>;
}
