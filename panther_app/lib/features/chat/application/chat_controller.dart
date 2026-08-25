import 'package:flutter/foundation.dart';
import '../../../data/models/chat_message.dart';
import '../../../data/services/demo_ai_service.dart';
import '../../memory/application/memory_controller.dart';

class ChatController extends ChangeNotifier {
  ChatController({required this.aiService, required this.memory});

  final DemoAiService aiService;

  /// So the demo reply can reference how much context PANTHER is "holding" —
  /// same behavior as the web app's TurnContext.items.length.
  final MemoryController memory;

  final List<ChatMessage> _messages = [];
  bool _isStreaming = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isStreaming => _isStreaming;

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isStreaming) return;

    final userMessage = ChatMessage(
      id: '${DateTime.now().microsecondsSinceEpoch}-u',
      role: MessageRole.user,
      content: trimmed,
      createdAt: DateTime.now(),
    );
    var assistantMessage = ChatMessage(
      id: '${DateTime.now().microsecondsSinceEpoch}-a',
      role: MessageRole.assistant,
      content: '',
      createdAt: DateTime.now(),
    );

    _messages.add(userMessage);
    _messages.add(assistantMessage);
    _isStreaming = true;
    notifyListeners();

    var accumulated = '';
    await for (final delta in aiService.streamReply(trimmed, memoryItemCount: memory.entries.length)) {
      accumulated += delta;
      final index = _messages.indexWhere((m) => m.id == assistantMessage.id);
      if (index == -1) break;
      assistantMessage = assistantMessage.copyWith(content: accumulated);
      _messages[index] = assistantMessage;
      notifyListeners();
    }

    _isStreaming = false;
    notifyListeners();
  }
}
