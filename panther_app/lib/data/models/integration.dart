import 'package:flutter/material.dart';

/// One row in the Ecosystem hub. None of these are actually wired up to a
/// real backend yet, so every entry is static, illustrative content — the
/// UI architecture for connecting a service exists, but nothing here claims
/// to be live. See ecosystem_screen.dart.
class Integration {
  const Integration({
    required this.name,
    required this.icon,
    required this.color,
    required this.capabilities,
  });

  final String name;
  final IconData icon;
  final Color color;
  final List<String> capabilities;
}

const demoIntegrations = [
  Integration(
    name: 'Google Calendar',
    icon: Icons.calendar_month_rounded,
    color: Color(0xFF2B52D6),
    capabilities: ['Events', 'Reminders', 'Scheduling'],
  ),
  Integration(
    name: 'Gmail',
    icon: Icons.mail_outline_rounded,
    color: Color(0xFFD9433C),
    capabilities: ['Summaries', 'Drafts', 'Follow-ups'],
  ),
  Integration(
    name: 'Google Tasks',
    icon: Icons.check_circle_outline_rounded,
    color: Color(0xFF0E8F63),
    capabilities: ['Task sync', 'Due dates'],
  ),
  Integration(
    name: 'Notion',
    icon: Icons.description_outlined,
    color: Color(0xFF13151C),
    capabilities: ['Pages', 'Databases', 'Notes'],
  ),
  Integration(
    name: 'Google Drive',
    icon: Icons.folder_outlined,
    color: Color(0xFFB4790A),
    capabilities: ['Documents', 'Search'],
  ),
  Integration(
    name: 'Web Search',
    icon: Icons.public_rounded,
    color: Color(0xFF54607A),
    capabilities: ['Live results', 'Citations'],
  ),
  Integration(
    name: 'Slack',
    icon: Icons.tag_rounded,
    color: Color(0xFF54607A),
    capabilities: ['Messages', 'Channels'],
  ),
];
