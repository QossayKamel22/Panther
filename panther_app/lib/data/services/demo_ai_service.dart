const _pantherVoiceNote =
    "(Demo mode — no AI provider is configured. Connect a real model to enable full reasoning.)";

/// Deterministic, dependency-free reply generator used until a real model
/// backend is wired in. Ported 1:1 from the web app's `demoProvider.ts` so
/// PANTHER never looks broken while running standalone — it streams a
/// clearly-labeled, on-brand response instead of failing outright.
class DemoAiService {
  const DemoAiService();

  /// Streams the reply word-by-word so the UI exercises the same streaming
  /// path a real provider would use.
  Stream<String> streamReply(String userText, {required int memoryItemCount}) async* {
    final text = _composeReply(userText, memoryItemCount: memoryItemCount);
    for (final word in text.split(' ')) {
      await Future<void>.delayed(const Duration(milliseconds: 18));
      yield '$word ';
    }
  }

  String _composeReply(String userText, {required int memoryItemCount}) {
    final lower = userText.toLowerCase();
    final memoryNote = memoryItemCount > 0
        ? " I'm keeping $memoryItemCount thing${memoryItemCount == 1 ? '' : 's'} from memory in mind."
        : '';

    if (RegExp(r'what.*(matter|focus|priorit)').hasMatch(lower)) {
      return "You have three things worth attention today. The first is time-sensitive — I'd handle it before your next meeting. $_pantherVoiceNote$memoryNote";
    }
    if (RegExp(r'prepare|meeting').hasMatch(lower)) {
      return "Here's what I'd walk in knowing: the agenda, the last decision made on this topic, and one open question worth raising. $_pantherVoiceNote$memoryNote";
    }
    if (RegExp(r'remember').hasMatch(lower)) {
      return "Got it — I've saved that. I'll bring it back up when it's relevant. $_pantherVoiceNote";
    }
    if (userText.trim().isEmpty) {
      return "I'm here. Ask me what matters today, or tell me something to remember. $_pantherVoiceNote";
    }
    return "Understood. Here's my read: this is straightforward, and I'd move on it directly rather than overthink it. $_pantherVoiceNote$memoryNote";
  }
}
