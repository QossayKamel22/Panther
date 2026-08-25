# PANTHER Architecture

This document describes the actual state of the codebase as of this build. It
is updated alongside the code — nothing here is aspirational unless
explicitly marked as planned.

## Stack

- **Framework:** Next.js 16 (App Router), TypeScript, single deployable app
  (frontend + backend in one).
- **UI:** React 19, Tailwind CSS v4, a small custom design system
  (`src/app/globals.css`) built from the PANTHER brand colors.
- **AI:** Provider-agnostic orchestration layer with a demo provider (works
  with no API key) and an Anthropic provider (used automatically once
  `ANTHROPIC_API_KEY` is set).
- **Persistence:** In-memory store for the MVP (`src/lib/memory`). Designed
  to be swapped for Postgres/Firestore without touching any calling code.
- **Tests:** Vitest, covering the tool router, memory store, and demo AI
  provider.

## Why one app instead of separate frontend/backend

There was no existing backend to preserve, and the product only needs a
single page plus a couple of API routes today. Next.js API routes serve as
the backend; the service layer underneath them (`src/lib/*`) is written so a
dedicated backend (NestJS, per the original brief) can be introduced later by
moving these modules wholesale — they have no framework-specific code in
them beyond the route handlers.

## Layering

```
Interface (src/components)
   -> API routes (src/app/api/*)
      -> AI Orchestrator (src/lib/ai/orchestrator.ts)
         -> Context Engine (src/lib/context/contextEngine.ts)
            -> Memory (src/lib/memory)
         -> AI Provider (src/lib/ai/providers/*)
      -> Tool Router (src/lib/tools/router.ts)
         -> Individual tools (src/lib/tools/tools/*)
```

Each layer only depends on the interfaces of the layer below it
(`AIProvider`, `MemoryStore`, `ToolDefinition`), not concrete
implementations. This is what lets the demo provider and a real provider
coexist, and what will let a real calendar/email/task integration replace
today's placeholder tool implementations without changing the orchestrator,
the API routes, or the UI.

## AI Orchestrator

`orchestrateTurn()` is the single entry point the `/api/chat` route calls. It:

1. Asks the Context Engine to build a `TurnContext` (recent conversation +
   relevant memory) for the latest user message.
2. Picks the Anthropic provider if `ANTHROPIC_API_KEY` is configured,
   otherwise falls back to the demo provider — the UI never sees the
   difference beyond response quality.
3. Streams `AIStreamChunk`s back to the route, which re-streams them to the
   browser over Server-Sent Events.

## Context Engine

`buildTurnContext()` currently pulls only from memory (short-term
conversation window + relevant long-term entries). It is the single seam
where future context sources — calendar, email, documents, connected
services — plug in without the orchestrator needing to change.

## Memory

`MemoryStore` (src/lib/memory/types.ts) defines `list/add/remove/search`.
The current implementation (`InMemoryMemoryStore`) is process-local and
resets on server restart — acceptable for a demo, not for production.
Memory is never written silently: the only way an entry is created is
through the explicit `memory.remember` tool, which is only invoked in
response to a direct user instruction ("remember this...").

## Tool System

Each tool in `src/lib/tools/tools/` implements `ToolDefinition`: a name, a
description, an input validator, a `requiresConfirmation` flag, and an
`execute()` function. The Tool Router (`src/lib/tools/router.ts`) is the only
thing that ever calls a tool directly — it validates input first and refuses
to run confirmation-required tools without `{ confirmed: true }`.

Implemented tools today: `calendar.query`, `task.create`, `memory.remember`,
`search.query`. Every one of them is currently a demo implementation with
clearly labeled placeholder data — none of them talk to a real calendar,
task system, or search index yet (see docs/ROADMAP.md, Phase 4).

## Frontend

The entire user-facing product is one screen (`src/app/page.tsx` →
`PantherApp`): a chat interface with an empty state offering starter
prompts, and a memory panel that opens as a slide-over rather than a
separate route. This is deliberate — the product brief calls for PANTHER to
stay a single coherent surface rather than growing new pages per feature.

## What is explicitly demo/placeholder right now

- Calendar, task, and search tools return static, labeled sample data.
- Memory persists only for the life of the server process.
- Without `ANTHROPIC_API_KEY`, all AI responses come from the deterministic
  demo provider (clearly labeled in its own output).

None of this is hidden from the user — the demo provider labels its own
responses, and the demo tools label their own output.
