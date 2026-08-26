import '../models/memory_entry.dart';

/// Deterministic, dependency-free reply generator used until a real model
/// backend is wired in. Streams pattern-matched, on-brand replies that pull
/// in whatever's actually in memory — a saved fact or instruction really
/// does shape the next answer, surfaced as a short briefing rather than
/// stitched awkwardly into a sentence.
class DemoAiService {
  const DemoAiService();

  static final _rememberPattern = RegExp(r'remember', caseSensitive: false);
  static final _rememberPrefix = RegExp(r'^remember\s+(that\s+|to\s+)?', caseSensitive: false);

  /// Whether [userText] is a "remember ___" request — the same check the
  /// demo reply uses to promise "Got it — I've saved that", so the two stay
  /// in sync instead of the reply claiming something the app didn't do.
  bool isRememberRequest(String userText) => _rememberPattern.hasMatch(userText);

  /// The part of a "remember ___" message worth actually saving — the
  /// instruction with the "remember that/to" lead-in stripped.
  String extractMemoryContent(String userText) {
    final stripped = userText.replaceFirst(_rememberPrefix, '').trim();
    return stripped.isEmpty ? userText.trim() : stripped;
  }

  /// Streams the reply word-by-word so the UI exercises the same streaming
  /// path a real provider would use.
  Stream<String> streamReply(String userText, {required List<MemoryEntry> memory}) async* {
    final text = _composeReply(userText, memory: memory);
    for (final word in text.split(' ')) {
      await Future<void>.delayed(const Duration(milliseconds: 18));
      yield '$word ';
    }
  }

  MemoryEntry? _find(List<MemoryEntry> memory, MemoryScope scope) {
    for (final e in memory) {
      if (e.scope == scope) return e;
    }
    return null;
  }

  String _composeReply(String userText, {required List<MemoryEntry> memory}) {
    final lower = userText.toLowerCase();
    final project = _find(memory, MemoryScope.project);
    final decision = _find(memory, MemoryScope.decision);
    final instruction = _find(memory, MemoryScope.instruction);
    final preference = _find(memory, MemoryScope.preference);
    final fact = _find(memory, MemoryScope.fact);

    if (RegExp(r'what.*(matter|focus|priorit|important)').hasMatch(lower)) {
      if (project == null) {
        return "Nothing's flagged yet. Tell me what you're working on and I'll start tracking what matters.";
      }
      final lines = ["Top priority: ${project.content}"];
      if (instruction != null) lines.add('Standing rule: ${instruction.content}');
      if (fact != null) lines.add(fact.content);
      return "Here's what's worth your attention today.\n\n${lines.map((l) => '• $l').join('\n')}";
    }
    if (RegExp(r'prepare|meeting').hasMatch(lower)) {
      if (project == null && decision == null) {
        return "I don't have context on this yet — tell me what the meeting's about and I'll start building it for next time.";
      }
      final lines = <String>[];
      if (project != null) lines.add('Context: ${project.content}');
      if (decision != null) lines.add('Last decision: ${decision.content}');
      if (preference != null) lines.add('Keep it in your style: ${preference.content}');
      return "Here's what I'd walk in knowing.\n\n${lines.map((l) => '• $l').join('\n')}";
    }
    if (RegExp(r'think.*through|help me think').hasMatch(lower)) {
      final rule = instruction != null ? '\n\nOne thing to weigh: ${instruction.content}' : '';
      return "Let's work through it. What's the real constraint here — time, budget, or buy-in?$rule";
    }
    if (isRememberRequest(userText)) {
      return "Got it — saved. I'll bring it back up whenever it's relevant.";
    }
    if (userText.trim().isEmpty) {
      return "I'm here. Ask what matters today, or tell me something to remember.";
    }
    final note = project != null ? "\n\nWorth weighing against: ${project.content}" : '';
    return "Understood. My read: this is straightforward — I'd move on it directly rather than let it sit.$note";
  }
}
