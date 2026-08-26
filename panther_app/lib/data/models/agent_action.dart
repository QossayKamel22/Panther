enum ActionState { pending, approved, rejected }

/// One thing PANTHER wants to do on the user's behalf. This whole feature
/// is a demo/mock data layer — approving or rejecting just moves the item
/// between local lists in ActionsController, nothing external is actually
/// sent. Wiring it to a real backend later only means swapping the
/// repository this controller talks to.
class AgentAction {
  const AgentAction({
    required this.id,
    required this.title,
    required this.detail,
    required this.state,
    this.destructive = false,
  });

  final String id;
  final String title;
  final String detail;
  final ActionState state;
  final bool destructive;

  AgentAction copyWith({ActionState? state}) => AgentAction(
        id: id,
        title: title,
        detail: detail,
        state: state ?? this.state,
        destructive: destructive,
      );
}

const demoPendingActions = [
  AgentAction(
    id: 'a1',
    title: 'Send email update to investor',
    detail: 'Draft ready — summarizes this month\'s progress and the Q3 roadmap.',
    state: ActionState.pending,
    destructive: true,
  ),
  AgentAction(
    id: 'a2',
    title: 'Schedule follow-up meeting with Sarah',
    detail: 'Proposed: Thursday 2:00 PM, 30 minutes, based on her last reply.',
    state: ActionState.pending,
  ),
  AgentAction(
    id: 'a3',
    title: 'Create task: Prepare pitch deck',
    detail: 'Added to your task list with a due date of next Monday.',
    state: ActionState.pending,
  ),
];

const demoActivityHistory = [
  'Summarized 5 emails',
  'Searched the web for competitor pricing',
  'Updated project notes with today\'s decision',
];
