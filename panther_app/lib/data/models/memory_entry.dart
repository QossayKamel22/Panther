enum MemoryScope { preference, project, decision, instruction, fact }

class MemoryEntry {
  const MemoryEntry({
    required this.id,
    required this.scope,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final MemoryScope scope;
  final String content;
  final DateTime createdAt;

  factory MemoryEntry.fromMap(String id, Map<String, dynamic> map) {
    return MemoryEntry(
      id: id,
      scope: MemoryScope.values.firstWhere(
        (s) => s.name == map['scope'],
        orElse: () => MemoryScope.fact,
      ),
      content: map['content'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toMap() => {
        'scope': scope.name,
        'content': content,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };
}
