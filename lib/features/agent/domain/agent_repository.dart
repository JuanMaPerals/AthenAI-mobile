import 'agent_message.dart';

/// Repository for AI Agent interactions
abstract class AgentRepository {
  /// Send a user message and receive a response from the AI Ally
  /// 
  /// [text] - The user's message
  /// [conversationId] - Optional conversation ID to maintain context
  /// [mode] - Optional mode for specialized responses (QUICK_RISK_CHECK, etc.)
  /// [language] - User's preferred language (default: 'es')
  /// [userMode] - User's mode from onboarding (individual, caregiver, team)
  /// [explanationStyle] - User's preferred explanation style (stepByStep, concise)
  /// [easyReading] - Accessibility preference for simplified, step-by-step format
  /// [focusArea] - User's focus area (optional)
  /// [urls] - List of URLs extracted from the message for future WebCheck integration
  /// 
  /// Returns the AI Ally's response message
  Future<AgentMessage> sendUserMessage(
    String text, {
    String? conversationId,
    String? mode,
    String language = 'es',
    String? userMode,
    String? explanationStyle,
    bool? easyReading,
    String? focusArea,
    List<String>? urls,
  });

  /// Get the current conversation ID (if any)
  String? getCurrentConversationId();
}
