"use client";

import { useEffect, useState } from "react";
import type { MemoryEntry } from "@/lib/memory/types";

/**
 * Memory is surfaced as a slide-over panel rather than a separate page —
 * per the product rule that PANTHER stays a single-screen experience.
 */
export function MemoryPanel({ open, onClose }: { open: boolean; onClose: () => void }) {
  const [entries, setEntries] = useState<MemoryEntry[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!open) return;
    let cancelled = false;
    // eslint-disable-next-line react-hooks/set-state-in-effect -- intentional: kicks off the load for this open() transition
    setLoading(true);
    fetch("/api/memory")
      .then((r) => r.json())
      .then((data) => {
        if (!cancelled) setEntries(data.entries ?? []);
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [open]);

  async function remove(id: string) {
    setEntries((prev) => prev.filter((e) => e.id !== id));
    await fetch(`/api/memory?id=${id}`, { method: "DELETE" });
  }

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex justify-end" role="dialog" aria-modal="true" aria-label="Memory">
      <button
        aria-label="Close memory panel"
        onClick={onClose}
        className="absolute inset-0 bg-black/50 backdrop-blur-sm"
      />
      <div className="relative h-full w-full max-w-sm glass-surface animate-fade-up border-l border-white/5 p-6 flex flex-col gap-4 overflow-y-auto">
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-medium text-panther-white">Memory</h2>
          <button
            onClick={onClose}
            className="text-panther-silver-dim hover:text-panther-white transition-colors text-sm"
          >
            Close
          </button>
        </div>
        <p className="text-sm text-panther-silver-dim">
          What PANTHER remembers about you. Nothing is stored unless you explicitly ask it to.
        </p>
        {loading && <p className="text-sm text-panther-silver-dim animate-pulse-soft">Loading…</p>}
        {!loading && entries.length === 0 && (
          <p className="text-sm text-panther-silver-dim">Nothing saved yet.</p>
        )}
        <ul className="flex flex-col gap-2">
          {entries.map((entry) => (
            <li
              key={entry.id}
              className="group flex items-start justify-between gap-3 rounded-xl border border-white/5 bg-panther-surface/60 px-4 py-3 text-sm"
            >
              <div>
                <span className="block text-[10px] uppercase tracking-wide text-panther-accent mb-1">
                  {entry.scope}
                </span>
                <span className="text-panther-silver">{entry.content}</span>
              </div>
              <button
                onClick={() => remove(entry.id)}
                className="opacity-0 group-hover:opacity-100 transition-opacity text-panther-silver-dim hover:text-red-400 text-xs"
                aria-label={`Forget: ${entry.content}`}
              >
                Forget
              </button>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}
