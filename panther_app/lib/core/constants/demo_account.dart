import '../../data/models/memory_entry.dart';

/// A pre-seeded account used for the "View demo" entry point on the
/// Welcome screen — lets someone pitching PANTHER (e.g. to investors) get
/// into a populated account in one tap instead of typing credentials live.
/// The account exists on the real Firebase project with a handful of
/// realistic memory entries already saved; nothing sensitive lives in it.
class DemoAccount {
  const DemoAccount._();

  static const email = 'demo@pantherapp.io';
  static const password = 'PantherDemo2026!';

  /// Mirrors what's actually saved in Firestore for the demo account —
  /// used to seed [LocalMemoryRepository] so the demo still looks populated
  /// if Firebase happens to be unreachable when it's shown.
  static List<MemoryEntry> seedMemory() {
    final now = DateTime.now();
    final content = [
      (MemoryScope.preference, 'Prefers concise, direct answers over long explanations — no fluff.'),
      (MemoryScope.project, 'Leading the Q3 product launch for the mobile redesign.'),
      (MemoryScope.decision, 'Decided to prioritize the enterprise tier over the free tier for Q3.'),
      (MemoryScope.instruction, 'Always flag budget risks above \$10k before approving anything.'),
      (MemoryScope.fact, 'Based in San Francisco. Usually free for investor meetings on Tuesdays.'),
    ];
    return [
      for (var i = 0; i < content.length; i++)
        MemoryEntry(
          id: 'demo-seed-$i',
          scope: content[i].$1,
          content: content[i].$2,
          createdAt: now.subtract(Duration(hours: content.length - i)),
        ),
    ].reversed.toList();
  }
}
