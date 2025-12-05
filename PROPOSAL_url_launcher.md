# Dependency Proposal: url_launcher

## Current State
- HomePage has "Checklist básico" button that shows a "not available" snackbar
- No url_launcher dependency exists

## Needed For
- Review Center feature: "Preparar email con el informe" button
- Opens pre-filled email draft with mailto: link

## Dependency Details
```yaml
dependencies:
  url_launcher: ^6.2.2
```

## Pros
✅ **Industry standard**: Official Flutter plugin (~100M downloads)
✅ **Simple API**: `launchUrl(Uri.parse('mailto:...'))`
✅ **Cross-platform**: Android, iOS, Windows, Web, etc.
✅ **Lightweight**: ~20KB
✅ **Maintained by Flutter team**
✅ **No privacy concerns**: Just opens system apps (email client, browser)

## Cons
⚠️ **Requires user's email app**: If no email client installed, will fail gracefully
⚠️ **Platform-specific behavior**: Email pre-fill may not work perfectly on all platforms

## Security Implications
✅ **SAFE**: Only launches external URLs/apps via system APIs
✅ **No data collection**: Doesn't send data anywhere
✅ **User controlled**: User sees and approves what happens

## PersalOne Use Case
We'll use it ONLY for:
- `mailto:` links with pre-filled subject/body for review export
- All data stays local until user explicitly sends email

**VERDICT**: ✅ **SAFE AND NECESSARY**

---

## Recommendation
Add both dependencies:

```yaml
dependencies:
  shared_preferences: ^2.2.2  # For review persistence
  url_launcher: ^6.2.2        # For email export
```

Then run:
```cmd
flutter pub get
```
