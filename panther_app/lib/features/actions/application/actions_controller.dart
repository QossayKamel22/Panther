import 'package:flutter/foundation.dart';
import '../../../data/models/agent_action.dart';

/// Owns the demo Action Center's local state. Approve/reject only move an
/// item between in-memory lists — there's no backend behind this yet (see
/// AgentAction's doc comment), so nothing here should be mistaken for a
/// real action queue.
class ActionsController extends ChangeNotifier {
  List<AgentAction> _pending = List.of(demoPendingActions);
  final List<AgentAction> _completed = [];

  List<AgentAction> get pending => List.unmodifiable(_pending);
  List<AgentAction> get completed => List.unmodifiable(_completed);
  List<String> get history => demoActivityHistory;

  void approve(String id) => _resolve(id, ActionState.approved);
  void reject(String id) => _resolve(id, ActionState.rejected);

  void _resolve(String id, ActionState state) {
    final index = _pending.indexWhere((a) => a.id == id);
    if (index == -1) return;
    final resolved = _pending[index].copyWith(state: state);
    _pending = List.of(_pending)..removeAt(index);
    _completed.insert(0, resolved);
    notifyListeners();
  }
}
