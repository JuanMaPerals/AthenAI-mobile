import '../domain/agent_message.dart';
import '../domain/agent_repository.dart';
import 'agent_api_service.dart';

/// Concrete implementation of AgentRepository using the Agent API
class AgentRepositoryImpl implements AgentRepository {
  final AgentApiService _apiService;
  String? _currentConversationId;

  AgentRepositoryImpl({
    AgentApiService? apiService,
  }) : _apiService = apiService ?? AgentApiService();

  @override
  Future<AgentMessage> sendUserMessage(
    String text, {
    String? conversationId,
    String? mode,
    String language = 'es',
    // User preferences
    String? userMode,
    String? explanationStyle,
    bool? easyReading,
    String? focusArea,
    List<String>? urls,
  }) async {
    try {
      // Use provided conversationId or the one stored in memory
      final effectiveConversationId = conversationId ?? _currentConversationId;

      // Call the API with new /ally/message endpoint
      final response = await _apiService.sendMessage(
        message: text,
        conversationId: effectiveConversationId,
        language: language,
        mode: mode,
        // Pass user preferences to API
        userMode: userMode,
        explanationStyle: explanationStyle,
        easyReading: easyReading,
        focusArea: focusArea,
        urls: urls,
      );

      // Parse the V2 response object
      // Backend returns AllyMessageResponseV2 with structured data
      final replyText = response.reply;
      final metadata = response.metadata;

      // Store conversation ID if provided
      if (response.conversationId != null) {
        _currentConversationId = response.conversationId;
      }

      // Create AgentMessage from the reply
      // TODO: In future, we'll want to pass the full analysis data to UI
      final agentMessage = AgentMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: replyText,
        sender: AgentSender.agent,
        createdAt: metadata.generatedAt,
      );

      return agentMessage;
    } on AgentApiException {
      // Re-throw API exceptions so the UI can handle them
      rethrow;
    } catch (e) {
      // Wrap any other errors
      throw AgentApiException(
        'unexpected_error',
        'Ocurrió un error inesperado al enviar tu mensaje.',
        details: e.toString(),
      );
    }
  }

  @override
  String? getCurrentConversationId() {
    return _currentConversationId;
  }

  /// Reset the conversation (start a new one)
  void resetConversation() {
    _currentConversationId = null;
  }

  void dispose() {
    _apiService.dispose();
  }
}
