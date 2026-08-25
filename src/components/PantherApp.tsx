"use client";

import { useRef, useState } from "react";
import type { ChatMessage } from "@/lib/ai/types";
import { PantherMark } from "./PantherMark";
import { MemoryPanel } from "./MemoryPanel";

const SUGGESTIONS = [
  "What's important today?",
  "Prepare me for my meeting.",
  "Think this through with me.",
  "Remember that this project is my top priority.",
];

function newId() {
  return crypto.randomUUID();
}

export function PantherApp() {
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState("");
  const [isStreaming, setIsStreaming] = useState(false);
  const [memoryOpen, setMemoryOpen] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  async function send(text: string) {
    const trimmed = text.trim();
    if (!trimmed || isStreaming) return;

    const userMessage: ChatMessage = {
      id: newId(),
      role: "user",
      content: trimmed,
      createdAt: Date.now(),
    };
    const assistantMessage: ChatMessage = {
      id: newId(),
      role: "assistant",
      content: "",
      createdAt: Date.now(),
    };

    const nextMessages = [...messages, userMessage];
    setMessages([...nextMessages, assistantMessage]);
    setInput("");
    setIsStreaming(true);

    try {
      const res = await fetch("/api/chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ messages: nextMessages }),
      });

      if (!res.body) throw new Error("No response stream.");
      const reader = res.body.getReader();
      const decoder = new TextDecoder();
      let buffer = "";
      let accumulated = "";

      while (true) {
        const { done, value } = await reader.read();
        if (done) break;
        buffer += decoder.decode(value, { stream: true });
        const lines = buffer.split("\n\n");
        buffer = lines.pop() ?? "";

        for (const line of lines) {
          if (!line.startsWith("data:")) continue;
          const payload = line.slice(5).trim();
          if (!payload) continue;
          const chunk = JSON.parse(payload);
          if (chunk.type === "text" && chunk.delta) {
            accumulated += chunk.delta;
            setMessages((prev) =>
              prev.map((m) => (m.id === assistantMessage.id ? { ...m, content: accumulated } : m))
            );
          } else if (chunk.type === "error") {
            accumulated = chunk.error || "PANTHER couldn't complete that.";
            setMessages((prev) =>
              prev.map((m) => (m.id === assistantMessage.id ? { ...m, content: accumulated } : m))
            );
          }
        }
      }
    } catch {
      setMessages((prev) =>
        prev.map((m) =>
          m.id === assistantMessage.id
            ? { ...m, content: "I couldn't reach the AI service. Try again in a moment." }
            : m
        )
      );
    } finally {
      setIsStreaming(false);
      requestAnimationFrame(() => {
        scrollRef.current?.scrollTo({ top: scrollRef.current.scrollHeight, behavior: "smooth" });
      });
    }
  }

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    send(input);
  }

  return (
    <div className="relative flex min-h-screen flex-col">
      <header className="flex items-center justify-between px-6 py-5 sm:px-10">
        <div className="flex items-center gap-2.5">
          <PantherMark size={26} />
          <span className="text-sm font-medium tracking-wide text-panther-white">PANTHER</span>
        </div>
        <button
          onClick={() => setMemoryOpen(true)}
          className="rounded-full border border-white/10 px-4 py-1.5 text-xs text-panther-silver-dim transition-colors hover:border-panther-accent/40 hover:text-panther-white"
        >
          Memory
        </button>
      </header>

      <main ref={scrollRef} className="flex-1 overflow-y-auto px-4 sm:px-6">
        <div className="mx-auto flex h-full w-full max-w-2xl flex-col">
          {messages.length === 0 ? (
            <EmptyState onPick={send} />
          ) : (
            <div className="flex flex-col gap-6 py-8">
              {messages.map((m) => (
                <MessageBubble key={m.id} message={m} />
              ))}
            </div>
          )}
        </div>
      </main>

      <form onSubmit={handleSubmit} className="px-4 pb-6 pt-2 sm:px-6">
        <div className="mx-auto flex w-full max-w-2xl items-center gap-2 rounded-2xl glass-surface accent-glow px-4 py-3">
          <input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Ask PANTHER anything…"
            className="flex-1 bg-transparent text-sm text-panther-white placeholder:text-panther-silver-dim focus:outline-none"
            aria-label="Message PANTHER"
          />
          <button
            type="submit"
            disabled={isStreaming || !input.trim()}
            className="rounded-full bg-panther-accent px-4 py-1.5 text-xs font-medium text-white transition-opacity disabled:opacity-30"
          >
            {isStreaming ? "Thinking…" : "Send"}
          </button>
        </div>
      </form>

      <MemoryPanel open={memoryOpen} onClose={() => setMemoryOpen(false)} />
    </div>
  );
}

function EmptyState({ onPick }: { onPick: (text: string) => void }) {
  return (
    <div className="flex flex-1 flex-col items-center justify-center gap-8 py-16 text-center animate-fade-up">
      <PantherMark size={56} />
      <div className="space-y-2">
        <h1 className="text-2xl font-medium text-panther-white sm:text-3xl">Good to see you.</h1>
        <p className="text-sm text-panther-silver-dim">Ask PANTHER anything. It&rsquo;s thinking ahead.</p>
      </div>
      <div className="flex flex-wrap justify-center gap-2">
        {SUGGESTIONS.map((s) => (
          <button
            key={s}
            onClick={() => onPick(s)}
            className="rounded-full border border-white/10 bg-panther-surface/50 px-4 py-2 text-xs text-panther-silver transition-colors hover:border-panther-accent/40 hover:text-panther-white"
          >
            {s}
          </button>
        ))}
      </div>
    </div>
  );
}

function MessageBubble({ message }: { message: ChatMessage }) {
  const isUser = message.role === "user";
  return (
    <div className={`flex animate-fade-up ${isUser ? "justify-end" : "justify-start"}`}>
      <div
        className={`max-w-[85%] rounded-2xl px-4 py-3 text-sm leading-relaxed ${
          isUser
            ? "bg-panther-accent/90 text-white"
            : "glass-surface text-panther-silver"
        }`}
      >
        {message.content || <span className="animate-pulse-soft">•••</span>}
      </div>
    </div>
  );
}
