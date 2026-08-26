/// A behavioral observation shown on the Intelligence dashboard. Entirely
/// illustrative — PANTHER doesn't yet track real usage patterns to compute
/// these, so this is what the feature looks like once it does.
class Insight {
  const Insight({required this.icon, required this.text});
  final String icon;
  final String text;
}

const demoInsights = [
  Insight(icon: '⏱️', text: 'You are most productive between 9AM–12PM.'),
  Insight(icon: '📈', text: 'You completed 20% more tasks than last week.'),
  Insight(icon: '🗓️', text: 'You have 2 meetings tomorrow that may need preparation.'),
];

/// One bar in the "Weekly focus" chart — day label + relative value (0–1).
class WeeklyFocusPoint {
  const WeeklyFocusPoint(this.label, this.value);
  final String label;
  final double value;
}

const demoWeeklyFocus = [
  WeeklyFocusPoint('Mon', 0.62),
  WeeklyFocusPoint('Tue', 0.78),
  WeeklyFocusPoint('Wed', 0.55),
  WeeklyFocusPoint('Thu', 0.9),
  WeeklyFocusPoint('Fri', 0.71),
  WeeklyFocusPoint('Sat', 0.24),
  WeeklyFocusPoint('Sun', 0.15),
];
