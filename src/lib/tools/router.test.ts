import { describe, expect, it } from "vitest";
import { runTool, listTools, getTool } from "./router";

describe("tool router", () => {
  it("lists the registered tools", () => {
    const names = listTools().map((t) => t.name);
    expect(names).toEqual(
      expect.arrayContaining(["calendar.query", "task.create", "memory.remember", "search.query"])
    );
  });

  it("rejects an unknown tool", async () => {
    const result = await runTool("does.not.exist", {});
    expect(result.ok).toBe(false);
    expect(result.error).toMatch(/unknown tool/i);
  });

  it("rejects invalid input before execution", async () => {
    const result = await runTool("memory.remember", { content: "" });
    expect(result.ok).toBe(false);
  });

  it("blocks confirmation-required tools without confirmation", async () => {
    const result = await runTool("task.create", { title: "Follow up with legal" });
    expect(result.ok).toBe(false);
    expect(result.error).toMatch(/confirmation/i);
  });

  it("executes confirmation-required tools once confirmed", async () => {
    const result = await runTool(
      "task.create",
      { title: "Follow up with legal" },
      { confirmed: true }
    );
    expect(result.ok).toBe(true);
  });

  it("executes tools that do not require confirmation directly", async () => {
    const result = await runTool("calendar.query", { range: "today" });
    expect(result.ok).toBe(true);
    expect(Array.isArray(result.output)).toBe(true);
  });

  it("exposes each tool's declared confirmation requirement", () => {
    expect(getTool("task.create")?.requiresConfirmation).toBe(true);
    expect(getTool("calendar.query")?.requiresConfirmation).toBe(false);
  });
});
