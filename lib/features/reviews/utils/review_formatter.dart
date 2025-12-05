import '../domain/review_case.dart';

/// Utility class for formatting review cases into various output formats
class ReviewFormatter {
  /// Format a review case as plain text for clipboard or email
  static String formatAsPlainText(
    ReviewCase reviewCase, {
    required String caseTypeLabel,
    required String riskLevelLabel,
    required String signalsReviewedLabel,
    required String riskPerceivedLabel,
    required String decisionTakenLabel,
  }) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('Informe de revisión – PersalOne');
    buffer.writeln();

    // Date
    buffer.writeln('Fecha: ${reviewCase.getShortDate()}');
    buffer.writeln();

    // Case type
    buffer.writeln('$caseTypeLabel: ${_getCaseTypeDisplay(reviewCase.caseType)}');
    
    // Optional title
    if (reviewCase.title != null && reviewCase.title!.isNotEmpty) {
      buffer.writeln('Título del caso: ${reviewCase.title}');
    }
    buffer.writeln();

    // Checklist results
    buffer.writeln(signalsReviewedLabel);
    for (final item in reviewCase.checklistItems) {
      final checkbox = item.isChecked ? '[x]' : '[ ]';
      buffer.writeln('$checkbox ${item.label}');
    }
    buffer.writeln();

    // Risk level
    buffer.writeln('$riskPerceivedLabel: $riskLevelLabel');
    buffer.writeln();

    // Decision note
    buffer.writeln('$decisionTakenLabel:');
    buffer.writeln(reviewCase.decisionNote.isEmpty ? '(Sin decisión registrada)' : reviewCase.decisionNote);

    return buffer.toString();
  }

  /// Get display string for case type (fallback for missing translation)
  static String _getCaseTypeDisplay(ReviewCaseType type) {
    switch (type) {
      case ReviewCaseType.suspiciousMessage:
        return 'Mensaje sospechoso';
      case ReviewCaseType.callOrVoiceNote:
        return 'Llamada o nota de voz';
      case ReviewCaseType.linkOrWebsite:
        return 'Enlace o página web';
      case ReviewCaseType.phoneSettings:
        return 'Ajuste de tu teléfono';
      case ReviewCaseType.other:
        return 'Otro';
    }
  }

  /// Generate email subject line
  static String generateEmailSubject(ReviewCase reviewCase) {
    final titlePart = reviewCase.title != null && reviewCase.title!.isNotEmpty
        ? reviewCase.title
        : _getCaseTypeDisplay(reviewCase.caseType);
    
    return 'Informe PersalOne – ${reviewCase.getShortDate()} – $titlePart';
  }

  /// Generate mailto URI for email export
  static Uri generateMailtoUri(
    ReviewCase reviewCase, {
    required String plainTextBody,
  }) {
    final subject = Uri.encodeComponent(generateEmailSubject(reviewCase));
    final body = Uri.encodeComponent(plainTextBody);
    
    return Uri.parse('mailto:?subject=$subject&body=$body');
  }
}
