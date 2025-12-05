import 'agent_message.dart';

class Conversation {
  final String id;
  final List<AgentMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor from JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((msgJson) {
            final sender = msgJson['sender'] == 'user' 
                ? AgentSender.user 
                : AgentSender.agent;
            return AgentMessage.fromJson(msgJson as Map<String, dynamic>, sender);
          })
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messages': messages.map((m) => m.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper: Add a message to the conversation
  Conversation addMessage(AgentMessage message) {
    return Conversation(
      id: id,
      messages: [...messages, message],
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Helper: Create a new empty conversation
  factory Conversation.create() {
    final now = DateTime.now();
    return Conversation(
      id: '', // Will be set by backend
      messages: [],
      createdAt: now,
      updatedAt: now,
    );
  }
}
