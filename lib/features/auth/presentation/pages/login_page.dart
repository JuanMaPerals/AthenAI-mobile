import 'package:flutter/material.dart';
import 'package:persalone/l10n/app_localizations.dart';
import '../../data/auth_api_service.dart';
import '../../domain/auth_session.dart';
import '../../../../core/di/service_locator.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../onboarding/presentation/pages/onboarding_page.dart';

/// Social login providers
enum SocialProvider { google, github, linkedin }

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Navigate to the appropriate screen after successful login
  void _navigateAfterLogin() {
    if (!mounted) return;

    // Check onboarding completion status
    final onboardingPrefs = ServiceLocator().onboardingPreferencesRepository.current;
    
    // Navigate to onboarding if not completed, otherwise to home
    if (!onboardingPrefs.isCompleted) {
      Navigator.of(context).pushReplacementNamed(OnboardingPage.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get repository instance from service locator
      final authRepository = ServiceLocator().authRepository;

      await authRepository.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      _navigateAfterLogin();
    } on NetworkAuthException catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.networkErrorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.userMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.loginErrorGeneric),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _handleDemoMode() {
    // Create a demo session with dummy tokens
    final demoSession = AuthSession(
      accessToken: 'dummy-access-token',
      refreshToken: 'dummy-access-token-refreshed',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );

    // Set the session in the repository
    final authRepository = ServiceLocator().authRepository;
    authRepository.setSession(demoSession);

    // Navigate to the appropriate screen
    _navigateAfterLogin();
  }

  /// Handle social login button press
  /// TODO: Trigger backend/ZITADEL social login flow
  /// This will eventually redirect to backend endpoint that initiates OAuth flow
  void _onSocialLoginPressed(SocialProvider provider) {
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final providerName = switch (provider) {
      SocialProvider.google => 'Google',
      SocialProvider.github => 'GitHub',
      SocialProvider.linkedin => 'LinkedIn',
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Inicio de sesión con $providerName próximamente'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  /// Handle create account button press
  /// TODO: Navigate to registration flow or trigger backend registration
  void _handleCreateAccount() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Registro de cuenta nueva próximamente'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ===== HEADER SECTION =====
                  // Logo and title
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/persalone_logo.png',
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.loginHeaderTitle,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: scheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        // Security-focused subtitle
                        Text(
                          l10n.loginSecuritySubtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ===== SOCIAL LOGIN SECTION =====
                  // Social login buttons
                  _SocialLoginButton(
                    provider: SocialProvider.google,
                    label: l10n.loginWithGoogle,
                    icon: Icons.login,
                    onPressed: _isLoading ? null : () => _onSocialLoginPressed(SocialProvider.google),
                  ),
                  const SizedBox(height: 12),
                  _SocialLoginButton(
                    provider: SocialProvider.github,
                    label: l10n.loginWithGitHub,
                    icon: Icons.code,
                    onPressed: _isLoading ? null : () => _onSocialLoginPressed(SocialProvider.github),
                  ),
                  const SizedBox(height: 12),
                  _SocialLoginButton(
                    provider: SocialProvider.linkedin,
                    label: l10n.loginWithLinkedIn,
                    icon: Icons.work_outline,
                    onPressed: _isLoading ? null : () => _onSocialLoginPressed(SocialProvider.linkedin),
                  ),

                  const SizedBox(height: 32),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          l10n.loginOrDivider,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ===== EMAIL/PASSWORD SECTION =====
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: l10n.loginEmailLabel,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !_isLoading,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.loginErrorRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: l10n.loginPasswordLabel,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          enabled: !_isLoading,
                          onFieldSubmitted: (_) => _handleLogin(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.loginErrorRequired;
                            }
                            return null;
                          },
                        ),

                        // Password hint
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            l10n.loginPasswordHint,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.6),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login button
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(l10n.loginWithEmail),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Create account button
                        SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : _handleCreateAccount,
                            child: Text(l10n.loginCreateAccount),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Divider before demo mode
                  const Divider(),

                  const SizedBox(height: 16),

                  // Demo mode button (less prominent)
                  TextButton(
                    onPressed: _isLoading ? null : _handleDemoMode,
                    child: Text(
                      l10n.loginDemoMode,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Social login button widget
class _SocialLoginButton extends StatelessWidget {
  final SocialProvider provider;
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const _SocialLoginButton({
    required this.provider,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
        ),
      ),
    );
  }
}
