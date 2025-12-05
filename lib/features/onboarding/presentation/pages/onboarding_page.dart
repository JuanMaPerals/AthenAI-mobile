import 'package:flutter/material.dart';
import 'package:persalone/l10n/app_localizations.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../domain/user_mode.dart';
import '../../domain/onboarding_preferences.dart';

class OnboardingPage extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentStep = 0;
  late OnboardingPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = ServiceLocator().onboardingPreferencesRepository.current;
  }

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  Future<void> _saveAndExit() async {
    // Mark onboarding as completed and persist
    final completedPreferences = _preferences.copyWith(isCompleted: true);
    await ServiceLocator().onboardingPreferencesRepository.update(completedPreferences);
    
    // Navigate to HomePage (replacing the current route)
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
  }

  void _updateUserMode(UserMode mode) {
    setState(() {
      _preferences = _preferences.copyWith(userMode: mode);
    });
  }

  void _updateExplanationStyle(ExplanationStyle style) {
    setState(() {
      _preferences = _preferences.copyWith(explanationStyle: style);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.onboardingTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.onboardingIntro,
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        if (_currentStep == 0) ...[
                          Text(
                            l10n.onboardingQuestionWho,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _OptionTile<UserMode>(
                            value: UserMode.individual,
                            groupValue: _preferences.userMode,
                            label: l10n.onboardingOptionSelf,
                            onChanged: _updateUserMode,
                          ),
                          _OptionTile<UserMode>(
                            value: UserMode.caregiver,
                            groupValue: _preferences.userMode,
                            label: l10n.onboardingOptionFamily,
                            onChanged: _updateUserMode,
                          ),
                          _OptionTile<UserMode>(
                            value: UserMode.team,
                            groupValue: _preferences.userMode,
                            label: l10n.onboardingOptionTeam,
                            onChanged: _updateUserMode,
                          ),
                        ] else ...[
                          Text(
                            l10n.onboardingQuestionStyle,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _OptionTile<ExplanationStyle>(
                            value: ExplanationStyle.stepByStep,
                            groupValue: _preferences.explanationStyle,
                            label: l10n.onboardingOptionStepByStep,
                            onChanged: _updateExplanationStyle,
                          ),
                          _OptionTile<ExplanationStyle>(
                            value: ExplanationStyle.concise,
                            groupValue: _preferences.explanationStyle,
                            label: l10n.onboardingOptionConcise,
                            onChanged: _updateExplanationStyle,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _currentStep--;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(l10n.onboardingBtnCancel), 
                            ),
                          ),
                        ),
                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          label: _currentStep == 0 ? l10n.onboardingBtnNext : l10n.onboardingBtnSave,
                          onPressed: _currentStep == 0 ? _nextStep : _saveAndExit,
                        ),
                      ),
                    ],
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

class _OptionTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T> onChanged;

  const _OptionTile({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? scheme.primary : scheme.outline.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? scheme.primary.withValues(alpha: 0.05) : null,
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? scheme.primary : scheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? scheme.primary : scheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
