import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:persalone/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:persalone/l10n/app_localizations.dart';
import 'package:persalone/core/di/service_locator.dart';

void main() {
  setUp(() async {
    // Ensure Flutter binding is initialized
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // Mock SharedPreferences with empty initial values
    SharedPreferences.setMockInitialValues({});
    
    // Initialize PreferencesStorage before tests
    await ServiceLocator().initPreferencesStorage();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const OnboardingPage(),
    );
  }

  testWidgets('OnboardingPage renders title and options', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Get the localization context
    final BuildContext context = tester.element(find.byType(OnboardingPage));
    final l10n = AppLocalizations.of(context)!;

    // Verify title is present using actual localized string
    expect(find.text(l10n.onboardingTitle), findsOneWidget);

    // Verify intro text
    expect(find.text(l10n.onboardingIntro), findsOneWidget);

    // Verify \"Who are you using PersalOne for?\" question
    expect(find.text(l10n.onboardingQuestionWho), findsOneWidget);

    // Verify options are present
    expect(find.text(l10n.onboardingOptionSelf), findsOneWidget);
    expect(find.text(l10n.onboardingOptionFamily), findsOneWidget);
    expect(find.text(l10n.onboardingOptionTeam), findsOneWidget);

    // Verify \"Next\" button is present
    expect(find.text(l10n.onboardingBtnNext), findsOneWidget);
  });
}
