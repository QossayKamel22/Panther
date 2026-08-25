import { NextRequest, NextResponse } from "next/server";
import { memoryStore } from "@/lib/memory/inMemoryStore";
import { runTool } from "@/lib/tools/router";

export const runtime = "nodejs";

export async function GET() {
  const entries = await memoryStore.list();
  return NextResponse.json({ entries });
}

export async function POST(req: NextRequest) {
  const body = await req.json().catch(() => null);
  if (!body || typeof body.content !== "string") {
    return NextResponse.json({ error: "'content' is required." }, { status: 400 });
  }

  const result = await runTool("memory.remember", { content: body.content, scope: body.scope });
  if (!result.ok) {
    return NextResponse.json({ error: result.error }, { status: 400 });
  }
  return NextResponse.json({ ok: true, id: (result.output as { id: string }).id });
}

export async function DELETE(req: NextRequest) {
  const { searchParams } = new URL(req.url);
  const id = searchParams.get("id");
  if (!id) {
    return NextResponse.json({ error: "'id' query param is required." }, { status: 400 });
  }
  await memoryStore.remove(id);
  return NextResponse.json({ ok: true });
}
