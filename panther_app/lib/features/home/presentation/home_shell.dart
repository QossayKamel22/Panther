import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/adaptive_scaffold.dart';

/// The signed-in app shell: adaptive navigation (bottom bar / rail / sidebar,
/// see AdaptiveScaffold) wrapping a go_router [StatefulShellRoute] so each
/// tab keeps its own navigation stack and scroll position when switching.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    AdaptiveDestination(icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: 'Home'),
    AdaptiveDestination(
      icon: Icons.chat_bubble_outline_rounded,
      selectedIcon: Icons.chat_bubble_rounded,
      label: 'Conversation',
    ),
    AdaptiveDestination(icon: Icons.bookmark_outline_rounded, selectedIcon: Icons.bookmark_rounded, label: 'Memory'),
    AdaptiveDestination(icon: Icons.hub_outlined, selectedIcon: Icons.hub_rounded, label: 'Ecosystem'),
    AdaptiveDestination(icon: Icons.bolt_outlined, selectedIcon: Icons.bolt_rounded, label: 'Actions'),
    AdaptiveDestination(icon: Icons.insights_outlined, selectedIcon: Icons.insights_rounded, label: 'Intelligence'),
    AdaptiveDestination(icon: Icons.settings_outlined, selectedIcon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      destinations: _destinations,
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
      body: navigationShell,
    );
  }
}
