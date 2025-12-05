class AgentAction {
  final String id;
  final String type; // "checklist_item" | "quick_action" | "external_link"
  final String title;
  final String description;
  final Map<String, dynamic>? data;

  AgentAction({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.data,
  });

  // Factory constructor from JSON
  factory AgentAction.fromJson(Map<String, dynamic> json) {
    return AgentAction(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'data': data,
    };
  }
}
