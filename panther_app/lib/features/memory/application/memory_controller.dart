import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../data/models/memory_entry.dart';
import '../../../data/repositories/memory_repository.dart';

class MemoryController extends ChangeNotifier {
  MemoryController(this._repository, {this.uid}) {
    _listen();
  }

  void _listen() {
    _sub = _repository.watch().listen(
      (entries) {
        _entries = entries;
        _loading = false;
        _error = null;
        notifyListeners();
      },
      onError: (Object e) {
        _loading = false;
        _error =
            'Couldn\'t load your memory. Check your connection and try again.';
        notifyListeners();
      },
    );
  }

  void retry() {
    _sub.cancel();
    _loading = true;
    _error = null;
    notifyListeners();
    _listen();
  }

  /// Which user this controller's data belongs to (null = local/guest).
  /// Used only to decide, in main.dart's ProxyProvider, whether the signed-in
  /// user changed and a fresh controller (pointed at a fresh repository) is
  /// needed.
  final String? uid;

  final MemoryRepository _repository;
  late StreamSubscription<List<MemoryEntry>> _sub;

  List<MemoryEntry> _entries = [];
  bool _loading = true;
  String? _error;

  List<MemoryEntry> get entries => _entries;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> add({required MemoryScope scope, required String content}) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return Future.value();
    return _repository.add(scope: scope, content: trimmed);
  }

  Future<void> remove(String id) => _repository.remove(id);

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
