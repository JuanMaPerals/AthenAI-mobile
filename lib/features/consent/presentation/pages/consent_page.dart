import 'package:flutter/material.dart';
import 'package:persalone/l10n/app_localizations.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/pages/login_page.dart';

class ConsentPage extends StatelessWidget {
  static const String routeName = '/consent';

  const ConsentPage({super.key});

  void _acceptAndContinue(BuildContext context) {
    // Mark consent as accepted
    ServiceLocator().consentRepository.accept();
    
    // Navigate to Login Page (replacing current route)
    Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  // Icon or Logo could go here
                  Icon(
                    Icons.privacy_tip_outlined,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n.consentTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  _ConsentBullet(
                    icon: Icons.content_paste,
                    text: l10n.consentBulletCopyPasteOnly,
                  ),
                  const SizedBox(height: 24),
                  _ConsentBullet(
                    icon: Icons.cloud_outlined,
                    text: l10n.consentBulletBackendAI,
                  ),
                  const SizedBox(height: 24),
                  _ConsentBullet(
                    icon: Icons.verified_user_outlined,
                    text: l10n.consentBulletYouControl,
                  ),
                  const Spacer(),
                  PrimaryButton(
                    label: l10n.consentPrimaryButton,
                    onPressed: () => _acceptAndContinue(context),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Placeholder for future "See details" action
                      // Could open a webview or show a dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy policy link would open here')),
                      );
                    },
                    child: Text(l10n.consentSecondaryButton),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConsentBullet extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ConsentBullet({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 24,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
