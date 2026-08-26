enum MessageRole { user, assistant, system }

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.sources = const [],
  });

  final String id;
  final MessageRole role;
  final String content;
  final DateTime createdAt;

  /// Which context this reply actually drew on (e.g. "Calendar", "Memory")
  /// — shown as source chips under the message. Empty when nothing did.
  final List<String> sources;

  ChatMessage copyWith({String? content, List<String>? sources}) => ChatMessage(
        id: id,
        role: role,
        content: content ?? this.content,
        createdAt: createdAt,
        sources: sources ?? this.sources,
      );
}
