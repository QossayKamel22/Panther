import { describe, expect, it } from "vitest";
import { InMemoryMemoryStore } from "./inMemoryStore";

describe("memory store", () => {
  it("adds and lists entries newest first", async () => {
    const store = new InMemoryMemoryStore();
    const first = await store.add({ scope: "fact", content: "First", source: "user_explicit" });
    const second = await store.add({ scope: "fact", content: "Second", source: "user_explicit" });
    const entries = await store.list();
    expect(entries[0].id).toBe(second.id);
    expect(entries[1].id).toBe(first.id);
  });

  it("removes an entry by id", async () => {
    const store = new InMemoryMemoryStore();
    const entry = await store.add({ scope: "preference", content: "Dark mode", source: "user_explicit" });
    await store.remove(entry.id);
    expect(await store.list()).toHaveLength(0);
  });

  it("searches case-insensitively", async () => {
    const store = new InMemoryMemoryStore();
    await store.add({ scope: "project", content: "PANTHER launch is top priority", source: "user_explicit" });
    const results = await store.search("panther");
    expect(results).toHaveLength(1);
  });
});
