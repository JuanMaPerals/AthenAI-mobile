import 'package:flutter/material.dart';
import 'package:persalone/l10n/app_localizations.dart';
import '../../data/auth_api_service.dart';
import '../../domain/auth_session.dart';
import '../../../../core/di/service_locator.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../onboarding/presentation/pages/onboarding_page.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // PersalOne Logo and Title
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/persalone_logo.png',
                          height: 96,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.loginTitle,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Subtitle
                  Text(
                    l10n.loginSubtitle,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

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
                    ),
                    obscureText: true,
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
                  const SizedBox(height: 32),

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
                          : Text(l10n.loginButton),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Demo mode button
                  SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _handleDemoMode,
                      child: Text(l10n.loginDemoMode),
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
