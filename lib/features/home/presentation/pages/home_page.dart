import 'package:flutter/material.dart';
import 'package:persalone/l10n/app_localizations.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/di/service_locator.dart';
import '../../../onboarding/domain/user_mode.dart';
import '../../../agent/presentation/pages/agent_page.dart';
import '../../../pricing/presentation/pages/pricing_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  const HomePage({super.key});

  void _navigateToAgentWithMessage(BuildContext context, String message) {
    Navigator.of(context).pushNamed(
      AgentPage.routeName,
      arguments: {'initialMessage': message},
    );
  }

  String _getPersonalizedSubtitle(AppLocalizations l10n) {
    // Get onboarding preferences
    final onboardingRepo = ServiceLocator().onboardingPreferencesRepository;
    final preferences = onboardingRepo.current;

    // Select subtitle based on userMode
    // Note: These keys need to be added to intl_es.arb and intl_en.arb
    // Falling back to default if keys are missing
    try {
      switch (preferences.userMode) {
        case UserMode.individual:
          // Try to use personalized key, fallback to default
          return l10n.homeHeroSubtitle; // Will be: l10n.homeHeroSubtitleIndividual when key is added
        case UserMode.caregiver:
          return l10n.homeHeroSubtitle; // Will be: l10n.homeHeroSubtitleCaregiver when key is added
        case UserMode.team:
          return l10n.homeHeroSubtitle; // Will be: l10n.homeHeroSubtitleTeam when key is added
      }
    } catch (e) {
      // If there's any error, just return the default
      return l10n.homeHeroSubtitle;
    }
  }

  Widget _buildScenarioCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.primary.withValues(alpha: 0.15)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.primary.withValues(alpha: 0.08),
                ),
                child: Icon(
                  icon,
                  color: scheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: scheme.primary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/persalone_logo.png',
              height: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text('PersalOne'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsPage.routeName);
            },
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeHeroTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getPersonalizedSubtitle(l10n),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(
                  color: scheme.primary.withValues(alpha: 0.5),
                  thickness: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.homeBetaMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 24),
              
              // Scenario cards section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.primary.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scheme.primary.withValues(alpha: 0.08),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: scheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        l10n.homeHelpTodayTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildScenarioCard(
                context: context,
                title: l10n.homeScenarioScamsTitle,
                subtitle: l10n.homeScenarioScamsSubtitle,
                icon: Icons.security_outlined,
                onTap: () => _navigateToAgentWithMessage(
                  context,
                  l10n.agentChipSuspiciousMessage,
                ),
              ),
              const SizedBox(height: 12),
              _buildScenarioCard(
                context: context,
                title: l10n.homeScenarioPasswordsTitle,
                subtitle: l10n.homeScenarioPasswordsSubtitle,
                icon: Icons.lock_outline,
                onTap: () => _navigateToAgentWithMessage(
                  context,
                  l10n.agentChipPasswords,
                ),
              ),
              const SizedBox(height: 12),
              _buildScenarioCard(
                context: context,
                title: l10n.homeScenarioDeviceTitle,
                subtitle: l10n.homeScenarioDeviceSubtitle,
                icon: Icons.phone_android_outlined,
                onTap: () => _navigateToAgentWithMessage(
                  context,
                  l10n.homeScenarioDeviceSlowSubtitle,
                ),
              ),
              const SizedBox(height: 32),
              
              Text(
                l10n.homeQuickActions,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: l10n.homeTalkToAgent,
                onPressed: () {
                  Navigator.of(context).pushNamed(AgentPage.routeName);
                },
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: l10n.homeViewPlans,
                onPressed: () {
                  Navigator.of(context).pushNamed(PricingPage.routeName);
                },
                isSecondary: true,
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: l10n.homeBasicChecklist,
                onPressed: () {
                  Navigator.of(context).pushNamed('/checklist');
                },
                isSecondary: true,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.homeFooterNote,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
