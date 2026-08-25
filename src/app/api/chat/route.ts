import { NextRequest } from "next/server";
import { orchestrateTurn } from "@/lib/ai/orchestrator";
import { ChatMessage } from "@/lib/ai/types";

export const runtime = "nodejs";

interface ChatRequestBody {
  messages: ChatMessage[];
}

export async function POST(req: NextRequest) {
  let body: ChatRequestBody;
  try {
    body = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: "Invalid JSON body." }), { status: 400 });
  }

  if (!Array.isArray(body.messages) || body.messages.length === 0) {
    return new Response(JSON.stringify({ error: "'messages' must be a non-empty array." }), {
      status: 400,
    });
  }

  const lastUser = [...body.messages].reverse().find((m) => m.role === "user");

  const encoder = new TextEncoder();
  const stream = new ReadableStream({
    async start(controller) {
      try {
        for await (const chunk of orchestrateTurn(body.messages, lastUser?.content ?? "")) {
          controller.enqueue(encoder.encode(`data: ${JSON.stringify(chunk)}\n\n`));
          if (chunk.type === "done" || chunk.type === "error") break;
        }
      } catch (err) {
        const message = err instanceof Error ? err.message : "PANTHER couldn't complete that.";
        controller.enqueue(encoder.encode(`data: ${JSON.stringify({ type: "error", error: message })}\n\n`));
      } finally {
        controller.close();
      }
    },
  });

  return new Response(stream, {
    headers: {
      "Content-Type": "text/event-stream",
      "Cache-Control": "no-cache",
      Connection: "keep-alive",
    },
  });
}
