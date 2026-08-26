/// One row in Home's "Upcoming" timeline.
class TimelineEvent {
  const TimelineEvent({required this.time, required this.title});
  final String time;
  final String title;
}

enum PriorityStatus { notStarted, inProgress, done }

/// One row in Home's "Top priorities" list.
class PriorityItem {
  const PriorityItem({required this.title, required this.due, required this.status});
  final String title;
  final String due;
  final PriorityStatus status;
}

/// Illustrative Home-dashboard content — there's no calendar/task
/// integration behind this yet (see EcosystemScreen), so it's only ever
/// shown for the seeded demo account, which exists specifically to show
/// what PANTHER looks like once a day is full of real context. Real
/// accounts get honest empty/connect states instead — see DashboardScreen.
class DemoDashboard {
  const DemoDashboard._();

  static const meetingsToday = 3;
  static const tasksToday = 7;
  static const deadlinesUpcoming = 2;
  static const focusHoursToday = '2.5h';

  static const timeline = [
    TimelineEvent(time: '10:30', title: 'Strategy Sync'),
    TimelineEvent(time: '2:00', title: 'Product Review'),
    TimelineEvent(time: '4:30', title: 'Marketing Sync'),
  ];

  static const priorities = [
    PriorityItem(title: 'Finalize Q3 investor update', due: 'Today', status: PriorityStatus.inProgress),
    PriorityItem(title: 'Review mobile redesign mockups', due: 'Tomorrow', status: PriorityStatus.notStarted),
    PriorityItem(title: 'Approve enterprise pricing tier', due: 'This week', status: PriorityStatus.notStarted),
  ];

  static const proactiveTip = 'You usually prepare for strategy syncs one day in advance.';
  static const proactiveAction = 'Prepare brief';
}
