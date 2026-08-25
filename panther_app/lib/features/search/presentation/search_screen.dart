import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/memory_tile.dart';
import '../../../data/models/memory_entry.dart';
import '../../memory/application/memory_controller.dart';

/// Search across what PANTHER remembers — the same entries as the Memory
/// screen, filtered by a live text query instead of browsed as a full list.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _query = TextEditingController();
  String _term = '';

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MemoryController>();
    final term = _term.trim().toLowerCase();
    final results = term.isEmpty
        ? const <MemoryEntry>[]
        : controller.entries
            .where((e) => e.content.toLowerCase().contains(term) || e.scope.name.contains(term))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _query,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search your memory…',
            border: InputBorder.none,
          ),
          onChanged: (v) => setState(() => _term = v),
        ),
      ),
      body: term.isEmpty
          ? const AppEmptyState(
              icon: Icons.search_rounded,
              title: 'Search what PANTHER remembers',
              message: 'Find a fact, preference, or decision by keyword.',
            )
          : controller.loading
              ? const AppLoadingState()
              : results.isEmpty
                  ? const AppEmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'No matches',
                      message: 'Nothing saved matches that search yet.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: results.length,
                      separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, i) => MemoryTile(entry: results[i]),
                    ),
    );
  }
}
