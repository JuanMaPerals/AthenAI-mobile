// lib/features/agent/domain/ally_message_response_v2.dart

/// V2 Response format for Ally message endpoint
class AllyMessageResponseV2 {
  final String responseId;
  final String reply;
  final AllyAnalysisResult? analysis;
  final String? conversationId;
  final AllyMetadata metadata;

  const AllyMessageResponseV2({
    required this.responseId,
    required this.reply,
    this.analysis,
    this.conversationId,
    required this.metadata,
  });

  factory AllyMessageResponseV2.fromJson(Map<String, dynamic> json) {
    try {
      return AllyMessageResponseV2(
        responseId: json['responseId'] as String? ?? '',
        reply: json['reply'] as String? ?? '',
        analysis: json['analysis'] != null
            ? AllyAnalysisResult.fromJson(json['analysis'] as Map<String, dynamic>)
            : null,
        conversationId: json['conversationId'] as String?,
        metadata: AllyMetadata.fromJson(json['metadata'] as Map<String, dynamic>? ?? {}),
      );
    } catch (e) {
      // Fallback for parsing errors
      return AllyMessageResponseV2(
        responseId: '',
        reply: json['reply'] as String? ?? 'Error al procesar la respuesta',
        analysis: null,
        conversationId: null,
        metadata: AllyMetadata(receivedLength: 0, hasContext: false, generatedAt: DateTime.now()),
      );
    }
  }
}

/// Structured analysis of the user's input
class AllyAnalysisResult {
  final AllyClassification classification;
  final AllyExtractedData extractedData;
  final AllyAdvice advice;
  final AllyReminderSuggestion? reminderSuggestion;
  final List<AllyEvent> events;

  const AllyAnalysisResult({
    required this.classification,
    required this.extractedData,
    required this.advice,
    this.reminderSuggestion,
    this.events = const [],
  });

  factory AllyAnalysisResult.fromJson(Map<String, dynamic> json) {
    return AllyAnalysisResult(
      classification: AllyClassification.fromJson(json['classification'] as Map<String, dynamic>? ?? {}),
      extractedData: AllyExtractedData.fromJson(json['extractedData'] as Map<String, dynamic>? ?? {}),
      advice: AllyAdvice.fromJson(json['advice'] as Map<String, dynamic>? ?? {}),
      reminderSuggestion: json['reminderSuggestion'] != null
          ? AllyReminderSuggestion.fromJson(json['reminderSuggestion'] as Map<String, dynamic>)
          : null,
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => AllyEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Classification of the situation
class AllyClassification {
  final String type; // scam_check, payment_review, login_security, device_issue, other
  final String riskLevel; // low, medium, high
  final double confidence;
  final String typeLabel;

  const AllyClassification({
    required this.type,
    required this.riskLevel,
    required this.confidence,
    required this.typeLabel,
  });

  factory AllyClassification.fromJson(Map<String, dynamic> json) {
    return AllyClassification(
      type: json['type'] as String? ?? 'other',
      riskLevel: json['riskLevel'] as String? ?? 'low',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      typeLabel: json['typeLabel'] as String? ?? '',
    );
  }
}

/// Data extracted from user's message
class AllyExtractedData {
  final List<ExtractedUrl> urls;
  final List<ExtractedContact> contacts;
  final List<ExtractedAmount> amounts;
  final List<ExtractedEntity> entities;

  const AllyExtractedData({
    this.urls = const [],
    this.contacts = const [],
    this.amounts = const [],
    this.entities = const [],
  });

  factory AllyExtractedData.fromJson(Map<String, dynamic> json) {
    return AllyExtractedData(
      urls: (json['urls'] as List<dynamic>?)?.map((e) => ExtractedUrl.fromJson(e as Map<String, dynamic>)).toList() ??
          [],
      contacts: (json['contacts'] as List<dynamic>?)
              ?.map((e) => ExtractedContact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      amounts: (json['amounts'] as List<dynamic>?)
              ?.map((e) => ExtractedAmount.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      entities: (json['entities'] as List<dynamic>?)
              ?.map((e) => ExtractedEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ExtractedUrl {
  final String url;
  final String domain;
  final bool suspicious;
  final String? suspiciousReason;

  const ExtractedUrl({
    required this.url,
    required this.domain,
    required this.suspicious,
    this.suspiciousReason,
  });

  factory ExtractedUrl.fromJson(Map<String, dynamic> json) {
    return ExtractedUrl(
      url: json['url'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      suspicious: json['suspicious'] as bool? ?? false,
      suspiciousReason: json['suspiciousReason'] as String?,
    );
  }
}

class ExtractedContact {
  final String type; // email, phone
  final String value;
  final bool suspected;

  const ExtractedContact({
    required this.type,
    required this.value,
    required this.suspected,
  });

  factory ExtractedContact.fromJson(Map<String, dynamic> json) {
    return ExtractedContact(
      type: json['type'] as String? ?? 'email',
      value: json['value'] as String? ?? '',
      suspected: json['suspected'] as bool? ?? false,
    );
  }
}

class ExtractedAmount {
  final double value;
  final String currency;
  final String formatted;

  const ExtractedAmount({
    required this.value,
    required this.currency,
    required this.formatted,
  });

  factory ExtractedAmount.fromJson(Map<String, dynamic> json) {
    return ExtractedAmount(
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'EUR',
      formatted: json['formatted'] as String? ?? '',
    );
  }
}

class ExtractedEntity {
  final String text;
  final String type; // bank, service, government, carrier, platform, other
  final bool legitimate;

  const ExtractedEntity({
    required this.text,
    required this.type,
    required this.legitimate,
  });

  factory ExtractedEntity.fromJson(Map<String, dynamic> json) {
    return ExtractedEntity(
      text: json['text'] as String? ?? '',
      type: json['type'] as String? ?? 'other',
      legitimate: json['legitimate'] as bool? ?? false,
    );
  }
}

/// Advice and guidance
class AllyAdvice {
  final String summary;
  final String explanation;
  final List<AllyRecommendedAction> recommendedActions;
  final List<ConditionalGuidance> conditionalGuidance;

  const AllyAdvice({
    required this.summary,
    required this.explanation,
    this.recommendedActions = const [],
    this.conditionalGuidance = const [],
  });

  factory AllyAdvice.fromJson(Map<String, dynamic> json) {
    return AllyAdvice(
      summary: json['summary'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      recommendedActions: (json['recommendedActions'] as List<dynamic>?)
              ?.map((e) => AllyRecommendedAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      conditionalGuidance: (json['conditionalGuidance'] as List<dynamic>?)
              ?.map((e) => ConditionalGuidance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AllyRecommendedAction {
  final int order;
  final String title;
  final String description;
  final String? icon; // block, verify, contact, delete, check, warning, info
  final bool urgent;

  const AllyRecommendedAction({
    required this.order,
    required this.title,
    required this.description,
    this.icon,
    required this.urgent,
  });

  factory AllyRecommendedAction.fromJson(Map<String, dynamic> json) {
    return AllyRecommendedAction(
      order: json['order'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String?,
      urgent: json['urgent'] as bool? ?? false,
    );
  }
}

class ConditionalGuidance {
  final String condition;
  final String action;

  const ConditionalGuidance({
    required this.condition,
    required this.action,
  });

  factory ConditionalGuidance.fromJson(Map<String, dynamic> json) {
    return ConditionalGuidance(
      condition: json['condition'] as String? ?? '',
      action: json['action'] as String? ?? '',
    );
  }
}

/// Suggestion for a future reminder
class AllyReminderSuggestion {
  final String label;
  final int suggestedDateOffsetDays;
  final String? description;

  const AllyReminderSuggestion({
    required this.label,
    required this.suggestedDateOffsetDays,
    this.description,
  });

  factory AllyReminderSuggestion.fromJson(Map<String, dynamic> json) {
    return AllyReminderSuggestion(
      label: json['label'] as String? ?? '',
      suggestedDateOffsetDays: json['suggestedDateOffsetDays'] as int? ?? 0,
      description: json['description'] as String?,
    );
  }
}

/// Backend event for analytics/monitoring
class AllyEvent {
  final String kind;
  final String severity; // info, warning, critical
  final Map<String, dynamic> metadata;

  const AllyEvent({
    required this.kind,
    required this.severity,
    this.metadata = const {},
  });

  factory AllyEvent.fromJson(Map<String, dynamic> json) {
    return AllyEvent(
      kind: json['kind'] as String? ?? 'other',
      severity: json['severity'] as String? ?? 'info',
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }
}

/// Metadata for backward compatibility
class AllyMetadata {
  final int receivedLength;
  final bool hasContext;
  final DateTime generatedAt;

  const AllyMetadata({
    required this.receivedLength,
    required this.hasContext,
    required this.generatedAt,
  });

  factory AllyMetadata.fromJson(Map<String, dynamic> json) {
    return AllyMetadata(
      receivedLength: json['receivedLength'] as int? ?? 0,
      hasContext: json['hasContext'] as bool? ?? false,
      generatedAt: json['generatedAt'] != null
          ? DateTime.tryParse(json['generatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
