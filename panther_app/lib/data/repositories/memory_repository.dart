import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/memory_entry.dart';

/// What PANTHER remembers about the signed-in user. Nothing is written
/// unless the user explicitly asks — mirrors the product rule from the web
/// app's MemoryPanel.
abstract class MemoryRepository {
  Stream<List<MemoryEntry>> watch();
  Future<MemoryEntry> add({required MemoryScope scope, required String content});
  Future<void> remove(String id);
}

class FirestoreMemoryRepository implements MemoryRepository {
  FirestoreMemoryRepository(this.uid);
  final String uid;

  CollectionReference<Map<String, dynamic>> get _collection =>
      FirebaseFirestore.instance.collection('users').doc(uid).collection('memory');

  @override
  Stream<List<MemoryEntry>> watch() {
    return _collection.orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs.map((d) => MemoryEntry.fromMap(d.id, d.data())).toList(),
        );
  }

  @override
  Future<MemoryEntry> add({required MemoryScope scope, required String content}) async {
    final entry = MemoryEntry(
      id: '',
      scope: scope,
      content: content,
      createdAt: DateTime.now(),
    );
    final ref = await _collection.add(entry.toMap());
    return MemoryEntry(id: ref.id, scope: scope, content: content, createdAt: entry.createdAt);
  }

  @override
  Future<void> remove(String id) => _collection.doc(id).delete();
}

/// In-memory fallback used until a real Firebase project is connected (see
/// FirebaseBootstrap) — keeps the Memory screen fully usable in local mode.
class LocalMemoryRepository implements MemoryRepository {
  LocalMemoryRepository({List<MemoryEntry> seed = const []}) : _entries = List.of(seed);

  final List<MemoryEntry> _entries;
  final _controller = StreamController<List<MemoryEntry>>.broadcast();

  @override
  Stream<List<MemoryEntry>> watch() async* {
    yield List.unmodifiable(_entries);
    yield* _controller.stream;
  }

  @override
  Future<MemoryEntry> add({required MemoryScope scope, required String content}) async {
    final entry = MemoryEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      scope: scope,
      content: content,
      createdAt: DateTime.now(),
    );
    _entries.insert(0, entry);
    _controller.add(List.unmodifiable(_entries));
    return entry;
  }

  @override
  Future<void> remove(String id) async {
    _entries.removeWhere((e) => e.id == id);
    _controller.add(List.unmodifiable(_entries));
  }
}
