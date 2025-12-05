import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:persalone/l10n/app_localizations.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/agent/presentation/pages/agent_page.dart';
import '../features/pricing/presentation/pages/pricing_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/consent/presentation/pages/consent_page.dart';
import '../features/reviews/presentation/pages/checklist_page.dart';
import '../features/reviews/presentation/pages/review_page.dart';
import '../core/di/service_locator.dart';
import 'theme.dart';

class PersalOneApp extends StatefulWidget {
  const PersalOneApp({super.key});

  @override
  State<PersalOneApp> createState() => _PersalOneAppState();
}

class _PersalOneAppState extends State<PersalOneApp> {
  @override
  Widget build(BuildContext context) {
    // Load accessibility settings from storage
    final accessibilityRepo = ServiceLocator().accessibilityRepository;
    final accessibilitySettings = accessibilityRepo.getCurrent();
    
    // Check if user is authenticated
    final authRepository = ServiceLocator().authRepository;
    final isAuthenticated = authRepository.currentSession != null;

    // Check if onboarding is completed
    final onboardingRepo = ServiceLocator().onboardingPreferencesRepository;
    final isOnboardingCompleted = onboardingRepo.current.isCompleted;

    // Check if consent is accepted
    final consentRepo = ServiceLocator().consentRepository;
    final isConsentAccepted = consentRepo.isAccepted;

    // Determine initial route
    String initialRoute;
    if (!isConsentAccepted) {
      initialRoute = ConsentPage.routeName;
    } else if (!isAuthenticated) {
      initialRoute = LoginPage.routeName;
    } else if (!isOnboardingCompleted) {
      initialRoute = OnboardingPage.routeName;
    } else {
      initialRoute = HomePage.routeName;
    }

    // Calculate text scale factor
    double textScaleFactor = 1.0;
    if (accessibilitySettings.largeText) {
      textScaleFactor = 1.3; // 30% larger
    }

    // Choose theme based on high contrast setting
    final theme = accessibilitySettings.highContrast
        ? buildHighContrastTheme()
        : buildPersalOneTheme();

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: theme,
      builder: (context, child) {
        // Apply text scale factor globally
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: child!,
        );
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],
      initialRoute: initialRoute,
      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        OnboardingPage.routeName: (_) => const OnboardingPage(),
        HomePage.routeName: (_) => const HomePage(),
        AgentPage.routeName: (_) => const AgentPage(),
        PricingPage.routeName: (_) => const PricingPage(),
        SettingsPage.routeName: (_) => const SettingsPage(),
        ConsentPage.routeName: (_) => const ConsentPage(),
        ChecklistPage.routeName: (_) => const ChecklistPage(),
        ReviewPage.routeName: (_) => const ReviewPage(),
      },
    );
  }
}
