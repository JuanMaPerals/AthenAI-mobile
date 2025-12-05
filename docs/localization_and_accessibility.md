# Localization and Accessibility

## Supported Languages

The app currently supports:
- **English** (`en`) - Default
- **Spanish** (`es`)

### How to add a new language (e.g., Catalan)

1.  **Create a new ARB file**:
    Create `lib/l10n/intl_ca.arb` by copying `lib/l10n/intl_en.arb`.

2.  **Translate strings**:
    Modify the values in `intl_ca.arb` to Catalan.
    ```json
    {
      "@@locale": "ca",
      "appTitle": "PersalOne",
      "homeTitle": "El meu estat de seguretat",
      ...
    }
    ```

3.  **Update `pubspec.yaml` (if needed)**:
    Ensure `flutter_localizations` is included (it usually is).

4.  **Run code generation**:
    Flutter automatically generates the Dart code when you run `flutter pub get` or build the app. The generated file `app_localizations.dart` will update to include the new locale.

5.  **Register the locale**:
    In `lib/app/persalone_app.dart` (or `main.dart`), add `Locale('ca')` to the `supportedLocales` list in `MaterialApp`.

## Adding a New Localized String

1.  **Open `lib/l10n/intl_en.arb`**.
2.  **Add the key-value pair**:
    ```json
    "newStringKey": "My New String",
    "@newStringKey": {
      "description": "Description of where this string is used"
    }
    ```
3.  **Add the translation** to `lib/l10n/intl_es.arb` (and other languages).
4.  **Use it in code**:
    ```dart
    Text(AppLocalizations.of(context)!.newStringKey)
    ```

## Accessibility Toggles

### Code Representation

-   **Model**: `AccessibilitySettings` class in `lib/core/accessibility/accessibility_settings.dart`.
    -   `largeText` (bool)
    -   `highContrast` (bool)
    -   `simplifiedLayout` (bool)

-   **Settings Page**: `SettingsPage` in `lib/features/settings/presentation/pages/settings_page.dart`.
    -   Uses `SwitchListTile` widgets to toggle these values.
    -   Currently, the state is managed locally in `_SettingsPageState` and is **not persisted**.

### Future Implementation

To make these toggles functional:

1.  **State Management**: Move `AccessibilitySettings` to a global state manager (e.g., `Provider`, `Riverpod`, or `Bloc`) so it can be accessed throughout the app.
2.  **Persistence**: Save the settings to `SharedPreferences` or a local database so they persist across app restarts.
3.  **Apply Changes**:
    -   **Large Text**: Wrap `MaterialApp` with `MediaQuery` to override `textScaler`, or use a custom `Theme` that scales font sizes based on the setting.
    -   **High Contrast**: Update the `ThemeData` in `MaterialApp` to use a high-contrast color scheme when enabled.
    -   **Simplified Layout**: In individual widgets, check the setting and conditionally hide decorative elements or simplify the UI structure.
