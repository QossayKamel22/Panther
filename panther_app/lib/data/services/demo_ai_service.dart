import '../models/memory_entry.dart';

enum _Intent { priorities, prepare, thinkThrough, remember, empty, general }

/// Deterministic, dependency-free reply generator used until a real model
/// backend is wired in. Streams pattern-matched, on-brand replies that pull
/// in whatever's actually in memory — a saved fact or instruction really
/// does shape the next answer, surfaced as a short briefing rather than
/// stitched awkwardly into a sentence.
///
/// [statusFor] and [sourcesFor] classify the same message the same way
/// [streamReply] does, so the "Reviewing your calendar…" status line and the
/// source chips shown under a reply always describe what actually produced
/// it — never a made-up chain of thought.
class DemoAiService {
  const DemoAiService();

  static final _rememberPattern = RegExp(r'remember', caseSensitive: false);
  static final _rememberPrefix = RegExp(r'^remember\s+(that\s+|to\s+)?', caseSensitive: false);
  static final _prioritiesPattern = RegExp(r'what.*(matter|focus|priorit|important)');
  static final _preparePattern = RegExp(r'prepare|meeting');
  static final _thinkPattern = RegExp(r'think.*through|help me think');

  bool isRememberRequest(String userText) => _rememberPattern.hasMatch(userText);

  String extractMemoryContent(String userText) {
    final stripped = userText.replaceFirst(_rememberPrefix, '').trim();
    return stripped.isEmpty ? userText.trim() : stripped;
  }

  /// The transient "what PANTHER is doing" line shown while a reply streams
  /// in — a status layer, not exposed chain-of-thought.
  String statusFor(String userText) => switch (_classify(userText)) {
        _Intent.priorities => 'Reviewing your calendar and priorities…',
        _Intent.prepare => 'Checking relevant project context…',
        _Intent.thinkThrough => 'Thinking it through with you…',
        _Intent.remember => 'Saving that to memory…',
        _Intent.empty => 'Here to help…',
        _Intent.general => 'Preparing your answer…',
      };

  /// Which source chips to show under the finished reply.
  List<String> sourcesFor(String userText, {required List<MemoryEntry> memory}) {
    final intent = _classify(userText);
    if (intent == _Intent.remember || intent == _Intent.empty) return const [];
    final sources = <String>[];
    if (intent == _Intent.priorities || intent == _Intent.prepare) sources.add('Calendar');
    if (memory.isNotEmpty) sources.add('Memory');
    return sources;
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

  _Intent _classify(String userText) {
    if (_prioritiesPattern.hasMatch(userText.toLowerCase())) return _Intent.priorities;
    if (_preparePattern.hasMatch(userText.toLowerCase())) return _Intent.prepare;
    if (_thinkPattern.hasMatch(userText.toLowerCase())) return _Intent.thinkThrough;
    if (isRememberRequest(userText)) return _Intent.remember;
    if (userText.trim().isEmpty) return _Intent.empty;
    return _Intent.general;
  }

  MemoryEntry? _find(List<MemoryEntry> memory, MemoryScope scope) {
    for (final e in memory) {
      if (e.scope == scope) return e;
    }
    return null;
  }

  String _composeReply(String userText, {required List<MemoryEntry> memory}) {
    final project = _find(memory, MemoryScope.project);
    final decision = _find(memory, MemoryScope.decision);
    final instruction = _find(memory, MemoryScope.instruction);
    final preference = _find(memory, MemoryScope.preference);
    final fact = _find(memory, MemoryScope.fact);

    switch (_classify(userText)) {
      case _Intent.priorities:
        if (project == null) {
          return "Nothing's flagged yet. Tell me what you're working on and I'll start tracking what matters.";
        }
        final lines = ["Top priority: ${project.content}"];
        if (instruction != null) lines.add('Standing rule: ${instruction.content}');
        if (fact != null) lines.add(fact.content);
        return "Here's what's worth your attention today.\n\n${lines.map((l) => '• $l').join('\n')}";

      case _Intent.prepare:
        if (project == null && decision == null) {
          return "I don't have context on this yet — tell me what the meeting's about and I'll start building it for next time.";
        }
        final lines = <String>[];
        if (project != null) lines.add('Context: ${project.content}');
        if (decision != null) lines.add('Last decision: ${decision.content}');
        if (preference != null) lines.add('Keep it in your style: ${preference.content}');
        return "Here's what I'd walk in knowing.\n\n${lines.map((l) => '• $l').join('\n')}";

      case _Intent.thinkThrough:
        final rule = instruction != null ? '\n\nOne thing to weigh: ${instruction.content}' : '';
        return "Let's work through it. What's the real constraint here — time, budget, or buy-in?$rule";

      case _Intent.remember:
        return "Got it — saved. I'll bring it back up whenever it's relevant.";

      case _Intent.empty:
        return "I'm here. Ask what matters today, or tell me something to remember.";

      case _Intent.general:
        final note = project != null ? "\n\nWorth weighing against: ${project.content}" : '';
        return "Understood. My read: this is straightforward — I'd move on it directly rather than let it sit.$note";
    }
  }
}
