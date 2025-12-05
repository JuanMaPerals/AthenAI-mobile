/// User profile model
class Profile {
  final String id;
  final String name;
  final String email;
  final String plan;
  final String language;
  final bool notificationsEnabled;

  const Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.plan,
    required this.language,
    required this.notificationsEnabled,
  });

  /// Create Profile from API response JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      plan: json['plan'] as String,
      language: json['language'] as String,
      notificationsEnabled: (json['preferences'] as Map<String, dynamic>)['notifications'] as bool,
    );
  }
}
