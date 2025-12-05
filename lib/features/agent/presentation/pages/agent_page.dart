import 'package:flutter/material.dart';
import 'package:persalone/l10n/app_localizations.dart';
import '../../domain/agent_message.dart';
import '../../domain/agent_repository.dart';
import '../../data/agent_repository_impl.dart';
import '../../data/agent_api_service.dart';
import '../../../auth/data/auth_api_service.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/beta_banner.dart';

class AgentPage extends StatefulWidget {
  static const String routeName = '/agent';

  const AgentPage({super.key});

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  final List<AgentMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final AgentRepository _repository = AgentRepositoryImpl();
  bool _sending = false;
  bool _hasProcessedInitialMessage = false;
  bool _showBetaBanner = true;

  @override
  void initState() {
    super.initState();
    // Load beta banner state from preferences
    _showBetaBanner = !ServiceLocator().preferencesStorage.getBetaBannerDismissed();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Handle initial message from navigation arguments
    if (!_hasProcessedInitialMessage) {
      _hasProcessedInitialMessage = true;
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final initialMessage = args?['initialMessage'] as String?;
      
      if (initialMessage != null && initialMessage.isNotEmpty) {
        // Use post-frame callback to ensure widget is fully built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.text = initialMessage;
          _handleSend();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismissBetaBanner() async {
    setState(() {
      _showBetaBanner = false;
    });
    await ServiceLocator().preferencesStorage.setBetaBannerDismissed(true);
  }

  void _handleChipTap(String message) {
    if (_sending) return;
    _controller.text = message;
    _handleSend();
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;

    // Create and add user message
    final userMessage = AgentMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      sender: AgentSender.user,
    );

    setState(() {
      _sending = true;
      _messages.add(userMessage);
      _controller.clear();
    });

    try {
      // Read user preferences from onboarding repository
      final prefs = ServiceLocator().onboardingPreferencesRepository.current;
      
      // Read accessibility preferences
      final accessibilitySettings = ServiceLocator().accessibilityRepository.getCurrent();
      
      // Convert enum values to strings for API
      final userMode = prefs.userMode.name; // 'individual', 'caregiver', 'team'
      final explanationStyle = prefs.explanationStyle.name; // 'stepByStep', 'concise'
      final easyReading = accessibilitySettings.simplifiedLayout; // Accessibility preference
      
      // Extract URLs from the message for future WebCheck integration
      final extractedUrls = _extractUrlsFromText(text);
      
      // Send message to AI Ally with user preferences
      final agentMessage = await _repository.sendUserMessage(
        text,
        conversationId: _repository.getCurrentConversationId(),
        language: 'es', // Could be configurable
        userMode: userMode,
        explanationStyle: explanationStyle,
        easyReading: easyReading,
        urls: extractedUrls,
        // focusArea: null, // Not yet collected in onboarding
      );

      // Add agent response to messages
      setState(() {
        _messages.add(agentMessage);
        _sending = false;
      });
    } on AuthException catch (_) {
      // Handle session expired (401)
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }

      // Clear the session
      ServiceLocator().authRepository.logout();

      if (!mounted) return;

      // Show session expired message
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.loginErrorSessionExpired),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

      // Redirect to login page
      Navigator.of(context).pushNamedAndRemoveUntil(
        LoginPage.routeName,
        (route) => false,
      );
    } on AgentApiException catch (e) {
      // Handle API errors gracefully
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }

      // Show error as a snackbar with localized message
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        final message = _mapErrorToLocalizedMessage(e, l10n);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            action: SnackBarAction(
              label: l10n.agentRetry,
              onPressed: () {
                if (!mounted) return;
                _controller.text = text;
                _handleSend();
              },
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.agentErrorUnexpected),
            action: SnackBarAction(
              label: l10n.agentRetry,
              onPressed: () {
                if (!mounted) return;
                _controller.text = text;
                _handleSend();
              },
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  String _mapErrorToLocalizedMessage(AgentApiException error, AppLocalizations l10n) {
    // Map error codes to localized messages
    switch (error.code) {
      case 'network_error':
        return l10n.agentErrorNetwork;
      case 'timeout':
        return l10n.agentErrorTimeout;
      default:
        // If the error has a specific user message, use it
        if (error.userMessage.isNotEmpty) {
          return error.userMessage;
        }
        return l10n.agentErrorUnexpected;
    }
  }

  Widget _buildSuggestionChips(AppLocalizations l10n) {
    if (_messages.isNotEmpty) return const SizedBox.shrink();
    
    final scheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildChip(
            label: l10n.agentChipSuspiciousMessage,
            onTap: () => _handleChipTap(l10n.agentChipSuspiciousMessage),
            scheme: scheme,
          ),
          _buildChip(
            label: l10n.agentChipBankEmail,
            onTap: () => _handleChipTap(l10n.agentChipBankEmail),
            scheme: scheme,
          ),
          _buildChip(
            label: l10n.agentChipPasswords,
            onTap: () => _handleChipTap(l10n.agentChipPasswords),
            scheme: scheme,
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required VoidCallback onTap,
    required ColorScheme scheme,
  }) {
    return InkWell(
      onTap: _sending ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: _sending 
                ? scheme.outline.withValues(alpha: 0.3)
                : scheme.primary.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(20),
          color: _sending 
              ? scheme.surface
              : scheme.primary.withValues(alpha: 0.05),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _sending 
                ? scheme.onSurface.withValues(alpha: 0.5)
                : scheme.primary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.agentTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(HomePage.routeName);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Beta banner at the top (dismissible)
            if (_showBetaBanner)
              BetaBanner(onDismiss: _dismissBetaBanner),
            
            Expanded(
              child: _messages.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          l10n.agentIntro,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final isUser = msg.sender == AgentSender.user;

                        return Align(
                          alignment:
                              isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? scheme.primary
                                  : scheme.primary.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Suggestion chips (shown only when no messages)
            _buildSuggestionChips(l10n),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: l10n.agentInputPlaceholder,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sending ? null : _handleSend,
                    icon: _sending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Extracts URLs from a text message for future WebCheck integration
  /// 
  /// Uses a simple RegExp to find http:// and https:// URLs
  /// Returns a list of unique URLs found in the text
  /// URLs are not cached or logged, only passed to the backend in the request
  List<String> _extractUrlsFromText(String text) {
    // RegExp to match http:// and https:// URLs
    // Matches protocol + domain + optional path/query/fragment
    final urlPattern = RegExp(
      r'https?://[^\s<>"{}|\\^\[\]`]+',
      caseSensitive: false,
    );
    
    final matches = urlPattern.allMatches(text);
    final urls = matches.map((match) => match.group(0)!).toSet().toList();
    
    return urls;
  }
}
