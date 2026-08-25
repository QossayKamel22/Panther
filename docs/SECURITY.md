# Security

## Current state

This is an MVP with no authentication layer yet — there is a single,
un-authenticated user session backed by a process-local memory store. Do not
deploy this build publicly with real user data.

## Secrets

- All secrets are read from environment variables (`process.env`), never
  hard-coded. See `.env.example` for the full list of expected variables —
  it contains placeholders only, never real values.
- `ANTHROPIC_API_KEY` is read server-side only, inside API route handlers and
  the Anthropic provider. It is never sent to the client bundle.
- `.env.local` (where real secrets belong) is covered by the default Next.js
  `.gitignore` and must never be committed.

## Input validation

Every tool validates its input before executing (`ToolDefinition.validate`
in `src/lib/tools/types.ts`). The Tool Router (`src/lib/tools/router.ts`)
refuses to execute a tool call whose input fails validation, and refuses to
execute any `requiresConfirmation` tool without an explicit
`{ confirmed: true }` — there is no path today for PANTHER to take an
action-with-side-effects without that flag being set by the caller.

The `/api/chat` and `/api/memory` routes validate their request bodies
(non-empty `messages` array, non-empty `content` string) and return 400s
with a message instead of throwing on malformed input.

## Planned, not yet built

- User authentication (Phase 4 territory — likely Firebase Auth per the
  original brief, or NextAuth).
- Per-user data isolation (today's memory store is shared process-wide,
  which is only acceptable for a single-user demo).
- Rate limiting on `/api/chat`.
- A real confirmation UI in the chat surface for `requiresConfirmation`
  tools — the backend already enforces the gate, but nothing in the UI yet
  surfaces "PANTHER wants to create a task — confirm?" as an interactive
  step.
