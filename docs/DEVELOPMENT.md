# Development

## Requirements

- Node.js 20+
- npm

## Setup

```bash
npm install
cp .env.example .env.local   # optional — the app runs fine with no keys set
npm run dev
```

Open http://localhost:3000. With no `ANTHROPIC_API_KEY` set, PANTHER runs in
demo mode — every response is clearly labeled as such.

## Scripts

| Command | Purpose |
| --- | --- |
| `npm run dev` | Start the dev server |
| `npm run build` | Production build |
| `npm run start` | Serve a production build |
| `npm run lint` | ESLint (Next.js config) |
| `npm test` | Run the Vitest suite |

## Project layout

```
src/
  app/
    page.tsx            single-screen entry point
    api/chat/route.ts    streaming chat endpoint
    api/memory/route.ts  memory CRUD endpoint
  components/            UI (PantherApp, MemoryPanel, PantherMark)
  lib/
    ai/                  orchestrator, provider contract, providers
    context/             context assembly for a turn
    memory/              MemoryStore contract + in-memory implementation
    tools/                tool contract, registry/router, individual tools
docs/                    this documentation set
```

## Adding a new tool

1. Create `src/lib/tools/tools/yourTool.ts` implementing `ToolDefinition`.
2. Register it in `src/lib/tools/router.ts`'s registry map.
3. Set `requiresConfirmation: true` if it can affect the user's external
   accounts or data.
4. Add a test in `src/lib/tools/router.test.ts` (or a dedicated test file)
   covering both valid and invalid input.

## Adding a new AI provider

Implement `AIProvider` (`src/lib/ai/types.ts`) in a new file under
`src/lib/ai/providers/`, then add it to the preference order in
`src/lib/ai/orchestrator.ts`.
