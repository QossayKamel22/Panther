import { ToolDefinition } from "../types";

interface SearchInput {
  query: string;
}

interface SearchResult {
  title: string;
  snippet: string;
}

/**
 * Demo web/document search. Real deployments should route this to a
 * configured search or retrieval provider; until one is configured this
 * returns a clearly labeled placeholder rather than fabricated results.
 */
export const searchTool: ToolDefinition<SearchInput, SearchResult[]> = {
  name: "search.query",
  description: "Search connected documents and the web for relevant information.",
  requiresConfirmation: false,
  validate(input) {
    const candidate = input as Record<string, unknown>;
    if (typeof candidate?.query !== "string" || candidate.query.trim().length === 0) {
      return { ok: false, error: "'query' must be a non-empty string." };
    }
    return { ok: true, input: { query: candidate.query } };
  },
  async execute(input) {
    return [
      {
        title: "(Demo mode)",
        snippet: `No search provider is configured, so I can't actually search for "${input.query}" yet. Connect a search integration to enable this.`,
      },
    ];
  },
};
