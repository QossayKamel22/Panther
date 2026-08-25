# AI Layer

## Providers

`AIProvider` (`src/lib/ai/types.ts`) is the contract every model backend
implements: an `id`, an `isConfigured` flag, and `streamCompletion(context)`
returning an async generator of `AIStreamChunk`.

- **Demo provider** (`src/lib/ai/providers/demoProvider.ts`): always
  configured, deterministic, dependency-free. Exists so the product never
  looks broken when no API key is set. Every response it produces says so
  explicitly.
- **Anthropic provider** (`src/lib/ai/providers/anthropicProvider.ts`): calls
  the Anthropic Messages API directly over `fetch` with `stream: true`,
  parses the SSE event stream, and yields text deltas. Only reports itself
  as configured when `ANTHROPIC_API_KEY` is present.

`orchestrateTurn()` picks whichever provider is configured, preferring the
real one. Adding a second real provider (e.g. OpenAI) means writing one more
file that implements `AIProvider` and adding it to the same preference check
in `src/lib/ai/orchestrator.ts` — nothing else changes.

## System prompt

The Anthropic provider's system prompt encodes the PANTHER personality from
the product brief: confident, concise, leads with the conclusion, never
pads with hedging language, and is explicit about not performing actions
silently. Iterating on personality/tone should happen in
`anthropicProvider.ts`'s `SYSTEM_PROMPT`, not scattered across the UI.

## Streaming

Both providers yield chunks over the same `AIStreamChunk` shape
(`{type: "text" | "tool_call" | "done" | "error", ...}`). `/api/chat` re-emits
these as Server-Sent Events; the client (`PantherApp.tsx`) appends text
deltas to the in-progress assistant message as they arrive, so the UI never
blocks on a full response.

## Tool calling (not yet wired to the model)

The tool system (`docs/ARCHITECTURE.md`) exists and is fully testable today,
but the AI providers do not yet decide when to call a tool — that decision
is currently made by the UI/demo layer, not the model. Wiring real
model-driven tool use (Anthropic's tool-use API) is Phase 2 work; the
`ToolCall` type and `AIStreamChunk`'s `tool_call` variant already exist in
anticipation of it.
