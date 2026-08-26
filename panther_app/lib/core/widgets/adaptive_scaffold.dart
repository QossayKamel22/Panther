import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/services/firebase_bootstrap.dart';
import '../../features/auth/application/auth_controller.dart';
import '../responsive/breakpoints.dart';
import 'panther_mark.dart';

class AdaptiveDestination {
  const AdaptiveDestination({required this.icon, required this.selectedIcon, required this.label});

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// One navigation shell that becomes a bottom nav bar on phones, and a
/// navigation rail (tablet) or a full labeled sidebar (desktop) on wider
/// viewports — so the product never looks like a stretched phone screen on
/// desktop, per the design brief.
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.floatingActionButton,
  });

  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return Scaffold(
        body: SafeArea(child: body),
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            for (final d in destinations)
              NavigationDestination(icon: Icon(d.icon), selectedIcon: Icon(d.selectedIcon), label: d.label),
          ],
        ),
      );
    }

    final expanded = context.isDesktop;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            _Sidebar(
              expanded: expanded,
              destinations: destinations,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: body,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.expanded,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final bool expanded;
  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    if (!expanded) {
      return NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        labelType: NavigationRailLabelType.all,
        leading: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: PantherMark(size: 26),
        ),
        destinations: [
          for (final d in destinations)
            NavigationRailDestination(icon: Icon(d.icon), selectedIcon: Icon(d.selectedIcon), label: Text(d.label)),
        ],
      );
    }

    return SizedBox(
      width: 240,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: PantherWordmark(markSize: 26, fontSize: 15),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < destinations.length; i++)
              _SidebarItem(
                destination: destinations[i],
                selected: i == selectedIndex,
                onTap: () => onDestinationSelected(i),
              ),
            const Spacer(),
            const _SidebarFooter(),
          ],
        ),
      ),
    );
  }
}

/// User identity + a real connection status (never an invented plan/billing
/// tier) at the base of the expanded sidebar.
class _SidebarFooter extends StatelessWidget {
  const _SidebarFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthController>();
    final name = auth.user?.displayNameOrFallback ?? 'Guest';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final connected = FirebaseBootstrap.isAvailable;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => context.push('/profile'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                child: Text(initial, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: connected ? const Color(0xFF0E8F63) : theme.colorScheme.outlineVariant,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(connected ? 'Connected' : 'Local mode', style: theme.textTheme.labelSmall),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({required this.destination, required this.selected, required this.onTap});

  final AdaptiveDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: selected ? scheme.primary.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                Icon(
                  selected ? destination.selectedIcon : destination.icon,
                  size: 20,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  destination.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: selected ? scheme.primary : scheme.onSurface,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
