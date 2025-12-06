import 'ally_message_response_v2.dart';

enum AgentSender {
  user,
  agent,
}

class AgentMessage {
  final String id;
  final String text;
  final AgentSender sender;
  final DateTime createdAt;
  final String? riskLevel; // "low" | "medium" | "high" | null
  final List<LinkAnalysis> linkAnalysis; // Link security analysis from backend

  AgentMessage({
    required this.id,
    required this.text,
    required this.sender,
    DateTime? createdAt,
    this.riskLevel,
    this.linkAnalysis = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  // Factory constructor from JSON (API response)
  factory AgentMessage.fromJson(Map<String, dynamic> json, AgentSender sender) {
    return AgentMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      sender: sender,
      createdAt: DateTime.parse(json['created_at'] as String),
      riskLevel: json['risk_level'] as String?,
      linkAnalysis: const [],
    );
  }

  // Convert to JSON for storage or API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sender': sender == AgentSender.user ? 'user' : 'agent',
      'created_at': createdAt.toIso8601String(),
      'risk_level': riskLevel,
    };
  }
}
