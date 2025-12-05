/// Repository to manage user consent state
/// Currently in-memory only, but designed to be extended for persistence
class ConsentRepository {
  bool _hasAcceptedPrivacy = false;

  /// Check if the user has accepted the privacy policy/consent
  bool get isAccepted => _hasAcceptedPrivacy;

  /// Mark consent as accepted
  void accept() {
    _hasAcceptedPrivacy = true;
  }
  
  /// Reset consent (useful for testing or logout)
  void reset() {
    _hasAcceptedPrivacy = false;
  }
}
