import 'package:flutter/foundation.dart';
import '../../../data/models/chat_message.dart';
import '../../../data/models/memory_entry.dart';
import '../../../data/services/demo_ai_service.dart';
import '../../memory/application/memory_controller.dart';

class ChatController extends ChangeNotifier {
  ChatController({required this.aiService, required this.memory});

  final DemoAiService aiService;

  /// So the demo reply can actually draw on what PANTHER remembers instead
  /// of just knowing how many things it's holding.
  final MemoryController memory;

  final List<ChatMessage> _messages = [];
  bool _isStreaming = false;
  String? _status;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isStreaming => _isStreaming;

  /// The transient "Reviewing your calendar…" line shown before the reply
  /// starts streaming in — cleared once real content arrives.
  String? get status => _status;

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
    _status = aiService.statusFor(trimmed);
    notifyListeners();

    if (aiService.isRememberRequest(trimmed)) {
      await memory.add(scope: MemoryScope.fact, content: aiService.extractMemoryContent(trimmed));
    }

    await Future<void>.delayed(const Duration(milliseconds: 280));

    var accumulated = '';
    var first = true;
    await for (final delta in aiService.streamReply(trimmed, memory: memory.entries)) {
      accumulated += delta;
      final index = _messages.indexWhere((m) => m.id == assistantMessage.id);
      if (index == -1) break;
      if (first) {
        _status = null;
        first = false;
      }
      assistantMessage = assistantMessage.copyWith(content: accumulated);
      _messages[index] = assistantMessage;
      notifyListeners();
    }

    final index = _messages.indexWhere((m) => m.id == assistantMessage.id);
    if (index != -1) {
      _messages[index] = assistantMessage.copyWith(
        sources: aiService.sourcesFor(trimmed, memory: memory.entries),
      );
    }

    _isStreaming = false;
    _status = null;
    notifyListeners();
  }
}
