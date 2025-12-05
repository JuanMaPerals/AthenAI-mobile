import 'user_mode.dart';

/// Holds the user's onboarding preferences
class OnboardingPreferences {
  final UserMode userMode;
  final ExplanationStyle explanationStyle;
  final bool isCompleted;

  const OnboardingPreferences({
    this.userMode = UserMode.individual,
    this.explanationStyle = ExplanationStyle.stepByStep,
    this.isCompleted = false,
  });

  OnboardingPreferences copyWith({
    UserMode? userMode,
    ExplanationStyle? explanationStyle,
    bool? isCompleted,
  }) {
    return OnboardingPreferences(
      userMode: userMode ?? this.userMode,
      explanationStyle: explanationStyle ?? this.explanationStyle,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OnboardingPreferences &&
        other.userMode == userMode &&
        other.explanationStyle == explanationStyle &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => userMode.hashCode ^ explanationStyle.hashCode ^ isCompleted.hashCode;
}
