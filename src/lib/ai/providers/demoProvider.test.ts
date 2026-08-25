import { describe, expect, it } from "vitest";
import { demoProvider } from "./demoProvider";
import { TurnContext } from "../types";

async function collectText(context: TurnContext): Promise<string> {
  let text = "";
  for await (const chunk of demoProvider.streamCompletion(context)) {
    if (chunk.type === "text" && chunk.delta) text += chunk.delta;
  }
  return text;
}

describe("demo AI provider", () => {
  it("is always configured (never breaks the app)", () => {
    expect(demoProvider.isConfigured).toBe(true);
  });

  it("responds directly to a priorities question", async () => {
    const text = await collectText({
      conversation: [{ id: "1", role: "user", content: "What should I focus on today?", createdAt: 0 }],
      items: [],
    });
    expect(text.toLowerCase()).toContain("today");
  });

  it("acknowledges memory context when present", async () => {
    const text = await collectText({
      conversation: [{ id: "1", role: "user", content: "Prepare me for my meeting.", createdAt: 0 }],
      items: [{ id: "m1", source: "memory", label: "fact", content: "Loves concise answers" }],
    });
    expect(text).toMatch(/1 thing/);
  });
});
