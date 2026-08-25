enum MessageRole { user, assistant, system }

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final MessageRole role;
  final String content;
  final DateTime createdAt;

  ChatMessage copyWith({String? content}) => ChatMessage(
        id: id,
        role: role,
        content: content ?? this.content,
        createdAt: createdAt,
      );
}
