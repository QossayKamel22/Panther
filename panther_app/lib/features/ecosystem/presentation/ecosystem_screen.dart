import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/integration_card.dart';
import '../../../data/models/integration.dart';

/// Connected Ecosystem hub. No service here is actually wired to a real
/// backend — every "Connect" action is an honest "on the roadmap" notice,
/// not a working connection. See IntegrationCard.
class EcosystemScreen extends StatelessWidget {
  const EcosystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final columns = context.isDesktop ? 3 : (context.isTablet ? 2 : 1);
    return Scaffold(
      appBar: AppBar(title: const Text('Ecosystem')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('Connected Ecosystem', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Connect your world. PANTHER handles the rest.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: demoIntegrations.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              mainAxisExtent: 200,
            ),
            itemBuilder: (context, i) => IntegrationCard(integration: demoIntegrations[i]),
          ),
        ],
      ),
    );
  }
}
