import { ToolDefinition } from "../types";

interface CalendarQueryInput {
  range: "today" | "tomorrow" | "week";
}

interface CalendarEvent {
  title: string;
  time: string;
  durationMinutes: number;
}

/**
 * Demo implementation: no calendar integration is connected yet, so this
 * returns clearly labeled sample data instead of pretending to read a real
 * calendar. Swap the execute() body for a real provider (Google/Microsoft
 * Graph) once integrations.calendar is configured — the contract here does
 * not change.
 */
export const calendarTool: ToolDefinition<CalendarQueryInput, CalendarEvent[]> = {
  name: "calendar.query",
  description: "Look up upcoming calendar events for a time range.",
  requiresConfirmation: false,
  validate(input) {
    const candidate = input as Record<string, unknown>;
    const range = candidate?.range;
    if (range !== "today" && range !== "tomorrow" && range !== "week") {
      return { ok: false, error: "'range' must be 'today', 'tomorrow', or 'week'." };
    }
    return { ok: true, input: { range } };
  },
  async execute() {
    return [
      { title: "(Demo) Product sync", time: "10:00", durationMinutes: 30 },
      { title: "(Demo) 1:1 with design", time: "14:00", durationMinutes: 45 },
    ];
  },
};
