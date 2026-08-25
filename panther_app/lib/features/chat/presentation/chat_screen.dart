import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/panther_mark.dart';
import '../../../data/models/chat_message.dart';
import '../application/chat_controller.dart';

const _suggestions = [
  "What's important today?",
  'Prepare me for my meeting.',
  'Think this through with me.',
  'Remember that this project is my top priority.',
];

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final value = text ?? _input.text;
    context.read<ChatController>().send(value);
    _input.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatController>();
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
          child: Row(
            children: [
              const PantherWordmark(markSize: 24, fontSize: 14),
              const Spacer(),
              IconButton(
                onPressed: () => context.push('/search'),
                icon: const Icon(Icons.search_rounded),
                tooltip: 'Search memory',
              ),
              IconButton(
                onPressed: () => context.push('/memory'),
                icon: const Icon(Icons.bookmark_border_rounded),
                tooltip: 'Memory',
              ),
            ],
          ),
        ),
        Expanded(
          child: chat.messages.isEmpty
              ? _EmptyState(onPick: _send)
              : ListView.separated(
                  controller: _scroll,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
                  itemCount: chat.messages.length,
                  separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, i) => _MessageBubble(message: chat.messages[i]),
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    decoration: const InputDecoration(
                      hintText: 'Ask PANTHER anything…',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: (_) => _send(),
                    textInputAction: TextInputAction.send,
                  ),
                ),
                IconButton(
                  onPressed: chat.isStreaming ? null : () => _send(),
                  icon: Icon(
                    Icons.arrow_upward_rounded,
                    color: chat.isStreaming ? theme.colorScheme.outlineVariant : theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PantherMark(size: 52),
            const SizedBox(height: AppSpacing.xl),
            Text('Good to see you.', style: theme.textTheme.headlineLarge),
            const SizedBox(height: AppSpacing.sm),
            Text("Ask PANTHER anything. It's thinking ahead.", style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.xxl),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: [
                for (final s in _suggestions)
                  ActionChip(
                    label: Text(s),
                    onPressed: () => onPick(s),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final theme = Theme.of(context);
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: isUser ? theme.colorScheme.primary : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: isUser ? null : Border.all(color: theme.colorScheme.outline),
          ),
          child: message.content.isEmpty
              ? SizedBox(
                  width: 24,
                  child: Text('•••', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                )
              : Text(
                  message.content,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                    height: 1.45,
                  ),
                ),
        ),
      ),
    );
  }
}
