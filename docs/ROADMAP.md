# PANTHER Roadmap

Reflects actual state. Phase 1 is done; everything past it is planned, not
built.

## Phase 1 — Foundation (done, this build)

- Next.js app with the PANTHER design system (colors, glass surfaces, motion)
  built from the brand direction in the master prompt.
- Single-screen chat experience with a memory slide-over panel.
- Clean service boundaries: AI Orchestrator, Context Engine, Memory, Tool
  Router — each behind an interface.
- Demo AI provider so the product works with zero configuration.
- Real AI provider (Anthropic) wired in and used automatically once
  `ANTHROPIC_API_KEY` is set.
- Four placeholder tools (`calendar.query`, `task.create`, `memory.remember`,
  `search.query`) with validation and confirmation gating.
- Vitest coverage for the tool router, memory store, and demo provider.

## Phase 2 — Intelligence

- Replace the hand-written demo heuristics with real reasoning: let the
  configured AI provider decide when to call a tool (tool-use / function
  calling), instead of the UI or orchestrator deciding for it.
- Add evaluation for response quality and tool-call correctness.
- Add per-turn cost/latency logging.

## Phase 3 — Memory

- Persist memory to a real database (Postgres or Firestore) behind the
  existing `MemoryStore` interface — no calling code should need to change.
- Add memory review/edit UI beyond the current list-and-forget panel.
- Add memory relevance ranking (embeddings) instead of substring search.

## Phase 4 — Integrations

- Replace the demo `calendar.query`, `task.create`, and `search.query` tools
  with real providers (Google/Microsoft Calendar, a real task backend, a real
  search/document index).
- Add an `emailTool` and `documentTool` per the original tool catalog.
- OAuth-based account connection flows, gated behind explicit user consent.

## Phase 5 — Agent Actions

- Let PANTHER execute multi-step plans across tools, not just single calls.
- Strengthen the confirmation UX (currently just a router-level gate) into a
  visible in-chat confirmation step for any `requiresConfirmation` tool.
- Add an audit log of every action PANTHER took on the user's behalf.

## Phase 6 — Mobile / Web Expansion

- Evaluate a Flutter client against the same API routes once the backend
  contract stabilizes.
- Push notifications for proactive insights.
- Responsive polish pass once real integrations are in place and there is
  more real content on screen to design around.
