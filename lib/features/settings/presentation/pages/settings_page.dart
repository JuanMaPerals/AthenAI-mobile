import 'package:flutter/material.dart';
import 'package:persalone/l10n/app_localizations.dart';
import '../../../../core/accessibility/accessibility_settings.dart';
import  '../../../../core/di/service_locator.dart';
import '../../domain/models/profile.dart';

import '../../../onboarding/presentation/pages/onboarding_page.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late AccessibilitySettings _settings;
  
  @override
  void initState() {
    super.initState();
    // Load current settings from storage
    final accessibilityRepo = ServiceLocator().accessibilityRepository;
    _settings = accessibilityRepo.getCurrent();
  }

  Future<void> _updateSettings(AccessibilitySettings newSettings) async {
    setState(() {
      _settings = newSettings;
    });
    
    // Persist to storage
    final accessibilityRepo = ServiceLocator().accessibilityRepository;
    await accessibilityRepo.update(newSettings);
    
    // Force app rebuild to apply new theme/text scaling
    if (mounted) {
      // Trigger a rebuild of the MaterialApp by using a GlobalKey
      // For now, settings will apply on next app restart
    }
  }

  Widget _buildBulletItem(String text, ColorScheme scheme, {bool canDo = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            canDo ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 20,
            color: canDo ? scheme.primary : scheme.error.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: scheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile section
          _ProfileSection(),

          const SizedBox(height: 24),

          // Security section (NEW)
          _SecuritySection(),

          const SizedBox(height: 24),

          // Onboarding / User Mode configuration
          ListTile(
            leading: Icon(Icons.person_outline, color: scheme.primary),
            title: Text(l10n.settingsOnboardingTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const OnboardingPage()),
              );
            },
          ),
          const Divider(),
          
          const SizedBox(height: 16),
          
          // Accessibility section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              l10n.settingsAccessibility,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),

          // Large text toggle
          SwitchListTile(
            title: Text(l10n.settingsLargeText),
            subtitle: Text(l10n.settingsLargeTextSubtitle),
            value: _settings.largeText,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(largeText: value));
            },
          ),

          const Divider(height: 1),

          // High contrast toggle
          SwitchListTile(
            title: Text(l10n.settingsHighContrast),
            subtitle: Text(l10n.settingsHighContrastSubtitle),
            value: _settings.highContrast,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(highContrast: value));
            },
          ),

          const Divider(height: 1),

          // Simplified layout toggle
          SwitchListTile(
            title: Text(l10n.settingsEasyReading),
            subtitle: Text(l10n.settingsEasyReadingSubtitle),
            value: _settings.simplifiedLayout,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(simplifiedLayout: value));
            },
          ),

          const SizedBox(height: 16),

          // Accessibility explanation text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.settingsAccessibilityExplanation,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.settingsInfoMessage,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // NEW: What PersalOne can/can't do section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              l10n.settingsWhatCanDoTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.primary,
              ),
            ),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Intro paragraph
                  Text(
                    l10n.settingsWhatCanDoIntro,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),

                  // "Can do" section
                  Text(
                    l10n.settingsWhatCanDoCanTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBulletItem(l10n.settingsWhatCanDoCanItem1, scheme, canDo: true),
                  _buildBulletItem(l10n.settingsWhatCanDoCanItem2, scheme, canDo: true),
                  _buildBulletItem(l10n.settingsWhatCanDoCanItem3, scheme, canDo: true),

                  const SizedBox(height: 20),

                  // "Cannot do" section
                  Text(
                    l10n.settingsWhatCanDoCannotTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: scheme.error.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBulletItem(l10n.settingsWhatCanDoCannotItem1, scheme, canDo: false),
                  _buildBulletItem(l10n.settingsWhatCanDoCannotItem2, scheme, canDo: false),
                  _buildBulletItem(l10n.settingsWhatCanDoCannotItem3, scheme, canDo: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper function to map plan codes to user-friendly labels
String _mapPlanToLabel(String plan, AppLocalizations l10n) {
  switch (plan.toLowerCase()) {
    case 'free':
      return l10n.settingsProfilePlanFree;
    default:
      // Fallback: show the raw plan but keep it calm and human
      return plan;
  }
}

/// Security recommendations section (2FA, passwords, etc.)
class _SecuritySection extends StatelessWidget {
  const _SecuritySection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.security_outlined,
                  color: scheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.settingsSecuritySectionTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: scheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2FA recommendation
            _SecurityBullet(
              icon: Icons.verified_user_outlined,
              text: l10n.settingsSecurity2FATitle,
            ),

            const SizedBox(height: 12),

            // Strong password recommendation
            _SecurityBullet(
              icon: Icons.password_outlined,
              text: l10n.settingsSecurityPasswordTitle,
            ),

            const SizedBox(height: 12),

            // Login activity recommendation
            _SecurityBullet(
              icon: Icons.history_outlined,
              text: l10n.settingsSecurityActivityTitle,
            ),

            const SizedBox(height: 16),

            // Info note about future implementation
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: scheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.settingsSecurityInfoNote,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Security bullet point widget
class _SecurityBullet extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SecurityBullet({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: scheme.primary.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.85),
            ),
          ),
        ),
      ],
    );
  }
}

/// Profile section widget that fetches and displays user profile
class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final profileApi = ServiceLocator().profileApiService;

    return FutureBuilder<Profile>(
      future: profileApi.fetchProfile(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      l10n.settingsProfileLoading,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Error state
        if (snapshot.hasError || !snapshot.hasData) {
          return Card(
            color: scheme.errorContainer.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: scheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.settingsProfileError,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Success - show profile data
        final profile = snapshot.data!;
        final planLabel = _mapPlanToLabel(profile.plan, l10n);

        return Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsProfileSectionTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                _ProfileRow(
                  label: l10n.settingsProfileNameLabel,
                  value: profile.name,
                  theme: theme,
                ),
                const SizedBox(height: 8),
                _ProfileRow(
                  label: l10n.settingsProfileEmailLabel,
                  value: profile.email,
                  theme: theme,
                ),
                const SizedBox(height: 8),
                _ProfileRow(
                  label: l10n.settingsProfilePlanLabel,
                  value: planLabel,
                  theme: theme,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Simple row for displaying profile field
class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _ProfileRow({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
