import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:persalone/app/persalone_app.dart';
import 'package:persalone/features/auth/presentation/pages/login_page.dart';
import 'package:persalone/features/consent/presentation/pages/consent_page.dart';
import 'package:persalone/core/widgets/primary_button.dart';
import 'package:persalone/core/di/service_locator.dart';

void main() {
  setUp(() async {
    // Ensure Flutter binding is initialized
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // Mock SharedPreferences with empty initial values
    // This will make the app start from ConsentPage (no consent accepted yet)
    SharedPreferences.setMockInitialValues({});
    
    // Initialize PreferencesStorage
    await ServiceLocator().initPreferencesStorage();
  });

  testWidgets('PersalOne starts at ConsentPage and navigates to LoginPage', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const PersalOneApp());
    
    // Let the first frame build and any initial navigation settle
    await tester.pumpAndSettle();

    // The app should start at ConsentPage (since consent is not accepted by default)
    expect(find.byType(ConsentPage), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);

    // Find and tap the accept button (PrimaryButton with specific text)
    // The ConsentPage has a primary accept button
    final acceptButtons = find.byType(PrimaryButton);
    expect(acceptButtons, findsAtLeastNWidgets(1));
    
    // Tap the first PrimaryButton (which should be the accept button)
    await tester.tap(acceptButtons.first);
    await tester.pumpAndSettle();

    // Now it should be at LoginPage (since user is not authenticated)
    expect(find.byType(ConsentPage), findsNothing);
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
