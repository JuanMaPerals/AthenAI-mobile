/// Review case type enumeration
enum ReviewCaseType {
  suspiciousMessage('suspicious_message'),
  callOrVoiceNote('call_or_voice'),
  linkOrWebsite('link_or_website'),
  phoneSettings('phone_settings'),
  other('other');

  final String value;
  const ReviewCaseType(this.value);

  static ReviewCaseType fromString(String value) {
    return ReviewCaseType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ReviewCaseType.other,
    );
  }
}

/// Risk level enumeration
enum RiskLevel {
  low('low'),
  medium('medium'),
  high('high');

  final String value;
  const RiskLevel(this.value);

  static RiskLevel fromString(String value) {
    return RiskLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => RiskLevel.low,
    );
  }
}

/// Single checklist item with checked state
class ChecklistItemResult {
  final String id;
  final String label;
  final bool isChecked;

  const ChecklistItemResult({
    required this.id,
    required this.label,
    required this.isChecked,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'isChecked': isChecked,
    };
  }

  factory ChecklistItemResult.fromJson(Map<String, dynamic> json) {
    return ChecklistItemResult(
      id: json['id'] as String,
      label: json['label'] as String,
      isChecked: json['isChecked'] as bool? ?? false,
    );
  }

  ChecklistItemResult copyWith({
    String? id,
    String? label,
    bool? isChecked,
  }) {
    return ChecklistItemResult(
      id: id ?? this.id,
      label: label ?? this.label,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

/// Model for a complete review case
class ReviewCase {
  final String id;
  final DateTime createdAt;
  final ReviewCaseType caseType;
  final String? title;
  final List<ChecklistItemResult> checklistItems;
  final RiskLevel riskLevel;
  final String decisionNote;

  const ReviewCase({
    required this.id,
    required this.createdAt,
    required this.caseType,
    this.title,
    required this.checklistItems,
    required this.riskLevel,
    required this.decisionNote,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'caseType': caseType.value,
      'title': title,
      'checklistItems': checklistItems.map((item) => item.toJson()).toList(),
      'riskLevel': riskLevel.value,
      'decisionNote': decisionNote,
    };
  }

  factory ReviewCase.fromJson(Map<String, dynamic> json) {
    return ReviewCase(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      caseType: ReviewCaseType.fromString(json['caseType'] as String),
      title: json['title'] as String?,
      checklistItems: (json['checklistItems'] as List<dynamic>)
          .map((item) => ChecklistItemResult.fromJson(item as Map<String, dynamic>))
          .toList(),
      riskLevel: RiskLevel.fromString(json['riskLevel'] as String),
      decisionNote: json['decisionNote'] as String,
    );
  }

  /// Get short date string for display (e.g., "04/12/2025")
  String getShortDate() {
    return '${createdAt.day.toString().padLeft(2, '0')}/'
        '${createdAt.month.toString().padLeft(2, '0')}/'
        '${createdAt.year}';
  }

  /// Get first line of decision note for preview
  String getDecisionPreview({int maxLength = 60}) {
    if (decisionNote.isEmpty) return 'Sin decisión registrada';
    
    final firstLine = decisionNote.split('\n').first.trim();
    if (firstLine.length <= maxLength) return firstLine;
    
    return '${firstLine.substring(0, maxLength)}...';
  }
}
