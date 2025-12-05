import 'package:flutter/material.dart';
import 'package:persalone/l10n/app_localizations.dart';
import '../../../../core/pricing/pricing_plans.dart';

class PricingPage extends StatelessWidget {
  static const String routeName = '/pricing';

  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pricingTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Beta banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: scheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      l10n.pricingBetaLabel.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.pricingBetaDisclaimerTitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.pricingBetaDisclaimerBody,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Individual plans section
            Text(
              l10n.pricingIndividualSectionTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildPlanCard(
              context: context,
              title: l10n.pricingIndividualFreeTitle,
              subtitle: l10n.pricingIndividualFreeSubtitle,
              features: kPersalOneFree.features,
              isFree: true,
            ),
            const SizedBox(height: 12),
            _buildPlanCard(
              context: context,
              title: l10n.pricingIndividualAllyTitle,
              subtitle: l10n.pricingIndividualAllySubtitle,
              features: kPersalOneAllyMonthly.features,
              price: '${kPersalOneAllyMonthly.priceMonth.toStringAsFixed(2).replaceAll('.', ',')} €/mes',
              yearlyPrice: '${kPersalOneAllyMonthly.priceYear.toStringAsFixed(0)} €/año',
            ),

            const SizedBox(height: 40),

            // Team plans section
            Text(
              l10n.pricingTeamSectionTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildTeamPlanCard(
              context: context,
              title: l10n.pricingTeamStartTitle,
              subtitle: l10n.pricingTeamStartSubtitle,
              features: kPersalOneTeamStart.features,
              price: kPersalOneTeamStart.priceText,
            ),
            const SizedBox(height: 12),
            _buildTeamPlanCard(
              context: context,
              title: l10n.pricingTeamGuardTitle,
              subtitle: l10n.pricingTeamGuardSubtitle,
              features: kPersalOneTeamGuard.features,
              price: kPersalOneTeamGuard.priceText,
            ),
            const SizedBox(height: 12),
            _buildTeamPlanCard(
              context: context,
              title: l10n.pricingTeamShieldTitle,
              subtitle: l10n.pricingTeamShieldSubtitle,
              features: kPersalOneTeamShield.features,
              price: kPersalOneTeamShield.priceText,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<String> features,
    bool isFree = false,
    String? price,
    String? yearlyPrice,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      elevation: isFree ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isFree ? scheme.outline.withValues(alpha: 0.3) : scheme.primary.withValues(alpha: 0.3),
          width: isFree ? 1 : 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),

            // Price
            if (isFree)
              Text(
                'Gratis',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              )
            else if (price != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    price,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: scheme.primary,
                    ),
                  ),
                  if (yearlyPrice != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      yearlyPrice,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            const SizedBox(height: 16),

            // Features
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: isFree ? scheme.onSurface.withValues(alpha: 0.5) : scheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamPlanCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<String> features,
    required String price,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: scheme.secondary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),

            // Price
            Text(
              price,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.secondary,
              ),
            ),
            const SizedBox(height: 16),

            // Features
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: scheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
