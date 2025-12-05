/// Accessibility settings model for PersalOne
library;

class AccessibilitySettings {
  final bool largeText;
  final bool highContrast;
  final bool simplifiedLayout;

  const AccessibilitySettings({
    this.largeText = false,
    this.highContrast = false,
    this.simplifiedLayout = false,
  });

  /// Default settings (all features disabled)
  factory AccessibilitySettings.defaults() {
    return const AccessibilitySettings();
  }

  /// Create from JSON (for future persistence)
  factory AccessibilitySettings.fromJson(Map<String, dynamic> json) {
    return AccessibilitySettings(
      largeText: json['largeText'] as bool? ?? false,
      highContrast: json['highContrast'] as bool? ?? false,
      simplifiedLayout: json['simplifiedLayout'] as bool? ?? false,
    );
  }

  /// Convert to JSON (for future persistence)
  Map<String, dynamic> toJson() {
    return {
      'largeText': largeText,
      'highContrast': highContrast,
      'simplifiedLayout': simplifiedLayout,
    };
  }

  /// Create a copy with updated values
  AccessibilitySettings copyWith({
    bool? largeText,
    bool? highContrast,
    bool? simplifiedLayout,
  }) {
    return AccessibilitySettings(
      largeText: largeText ?? this.largeText,
      highContrast: highContrast ?? this.highContrast,
      simplifiedLayout: simplifiedLayout ?? this.simplifiedLayout,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccessibilitySettings &&
        other.largeText == largeText &&
        other.highContrast == highContrast &&
        other.simplifiedLayout == simplifiedLayout;
  }

  @override
  int get hashCode {
    return Object.hash(largeText, highContrast, simplifiedLayout);
  }
}
