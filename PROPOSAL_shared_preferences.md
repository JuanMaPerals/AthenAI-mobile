# Proposal: Add `shared_preferences` Dependency

## Current State
- No local persistence mechanism exists in the app
- Onboarding and accessibility settings are stored only in memory
- Settings reset every time the app restarts

## Proposed Solution
Add `shared_preferences` package for local key-value storage.

## Dependency Details
```yaml
dependencies:
  shared_preferences: ^2.2.2
```

## Pros
✅ **Industry standard**: Most widely used Flutter persistence package (~50M downloads)
✅ **Simple API**: Key-value storage (String, int, bool, double, List<String>)
✅ **Cross-platform**: Works on Android, iOS, Web, Windows, Linux, macOS
✅ **Lightweight**: ~50KB, no database overhead
✅ **No setup required**: Works out of the box
✅ **Mature**: Maintained by Flutter team, stable API

## Cons
⚠️ **Not encrypted by default**: Data stored in plain text
⚠️ **Limited data types**: Only primitives (no complex objects without manual serialization)
⚠️ **Not for sensitive data**: Should NOT store passwords, tokens, or PII without encryption
⚠️ **Size limits**: Not suitable for large datasets (> 1MB)

## Security Implications

### Safe to Store
✅ Accessibility preferences (largeText, highContrast, easyReadingMode)
✅ Onboarding choices (userMode, explanationStyle, isCompleted)
✅ UI preferences (theme, language)

### NOT Safe to Store (without encryption)
❌ User passwords
❌ API access tokens (use secure_storage instead)
❌ Personal identifiable information
❌ Sensitive health/financial data

## For PersalOne Use Case
**VERDICT**: ✅ **SAFE AND APPROPRIATE**

We're only storing:
- Boolean flags for accessibility settings
- String enums for onboarding preferences (userMode, explanationStyle)
- Boolean completion flag

None of this is sensitive data. No user privacy concerns.

## Alternative Considered
- **flutter_secure_storage**: Overkill for non-sensitive preferences, adds complexity
- **Hive**: More powerful but unnecessary for simple key-value storage
- **sqflite**: Database is overkill for a few boolean/string values

## Recommendation
✅ **Add shared_preferences** - it's the right tool for this job.

Add to `pubspec.yaml`:
```yaml
dependencies:
  shared_preferences: ^2.2.2
```

Then run:
```cmd
flutter pub get
```

---

**Awaiting your confirmation to proceed.**
