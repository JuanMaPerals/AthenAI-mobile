class Environment {
  static const String apiBaseUrl = String.fromEnvironment(
    'PERSALONE_API_BASE_URL',
    defaultValue: 'https://api.athenacyberacademy.com', // Production API
  );
}
