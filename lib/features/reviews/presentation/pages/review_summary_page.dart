import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:persalone/l10n/app_localizations.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/review_case.dart';
import '../../utils/review_formatter.dart';

/// Page to view review summary and export it
class ReviewSummaryPage extends StatelessWidget {
  static const String routeName = '/review-summary';
  final ReviewCase reviewCase;

  const ReviewSummaryPage({
    super.key,
    required this.reviewCase,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final riskColor = _getRiskColor(reviewCase.riskLevel, scheme);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reviewSummaryTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.delete,
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              reviewCase.title ?? _getCaseTypeLabel(reviewCase.caseType, l10n),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Date
            Text(
              '${l10n.reviewDate}: ${reviewCase.getShortDate()}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            
            const SizedBox(height: 24),

            // Case type
            _buildInfoCard(
              context,
              title: l10n.reviewCaseType,
              content: _getCaseTypeLabel(reviewCase.caseType, l10n),
            ),

            const SizedBox(height: 16),

            // Checklist results
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.reviewSignalsReviewed,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...reviewCase.checklistItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              item.isChecked
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              size: 20,
                              color: item.isChecked
                                  ? scheme.primary
                                  : scheme.onSurface.withValues(alpha: 0.4),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.label,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Risk level
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: riskColor.withValues(alpha: 0.15),
                      ),
                      child: Icon(
                        _getRiskIcon(reviewCase.riskLevel),
                        color: riskColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.reviewRiskPerceived,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getRiskLevelLabel(reviewCase.riskLevel, l10n),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: riskColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Decision note
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.reviewDecisionTaken,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      reviewCase.decisionNote.isEmpty
                          ? l10n.reviewNoDecisionRecorded
                          : reviewCase.decisionNote,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Export actions
            Text(
              l10n.reviewExportActions,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Copy to clipboard button
            OutlinedButton.icon(
              onPressed: () => _copyToClipboard(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                minimumSize: const Size(double.infinity, 56),
              ),
              icon: const Icon(Icons.copy),
              label: Text(l10n.reviewCopyReport),
            ),

            const SizedBox(height: 12),

            // Prepare email button
            OutlinedButton.icon(
              onPressed: () => _prepareEmail(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                minimumSize: const Size(double.infinity, 56),
              ),
              icon: const Icon(Icons.email_outlined),
              label: Text(l10n.reviewPrepareEmail),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required String content}) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final plainText = ReviewFormatter.formatAsPlainText(
      reviewCase,
      caseTypeLabel: l10n.reviewCaseType,
      riskLevelLabel: _getRiskLevelLabel(reviewCase.riskLevel, l10n),
      signalsReviewedLabel: l10n.reviewSignalsReviewed,
      riskPerceivedLabel: l10n.reviewRiskPerceived,
      decisionTakenLabel: l10n.reviewDecisionTaken,
    );

    Clipboard.setData(ClipboardData(text: plainText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.reviewCopiedToClipboard),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _prepareEmail(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    final plainText = ReviewFormatter.formatAsPlainText(
      reviewCase,
      caseTypeLabel: l10n.reviewCaseType,
      riskLevelLabel: _getRiskLevelLabel(reviewCase.riskLevel, l10n),
      signalsReviewedLabel: l10n.reviewSignalsReviewed,
      riskPerceivedLabel: l10n.reviewRiskPerceived,
      decisionTakenLabel: l10n.reviewDecisionTaken,
    );

    final mailtoUri = ReviewFormatter.generateMailtoUri(reviewCase, plainTextBody: plainText);

    // Try to launch the email client
    try {
      final launched = await launchUrl(mailtoUri);
      
      if (!launched && context.mounted) {
        // If launching failed, copy to clipboard as fallback
        Clipboard.setData(ClipboardData(text: plainText));
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.reviewEmailNotAvailableYet),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // If there's an error, copy to clipboard as fallback
      if (context.mounted) {
        Clipboard.setData(ClipboardData(text: plainText));
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.reviewEmailNotAvailableYet),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.reviewDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              ServiceLocator().reviewsRepository.deleteCase(reviewCase.id);
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to checklist
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(RiskLevel level, ColorScheme scheme) {
    switch (level) {
      case RiskLevel.high:
        return scheme.error;
      case RiskLevel.medium:
        return Colors.orange;
      case RiskLevel.low:
        return Colors.green;
    }
  }

  IconData _getRiskIcon(RiskLevel level) {
    switch (level) {
      case RiskLevel.high:
        return Icons.warning;
      case RiskLevel.medium:
        return Icons.info;
      case RiskLevel.low:
        return Icons.check_circle;
    }
  }

  String _getCaseTypeLabel(ReviewCaseType type, AppLocalizations l10n) {
    switch (type) {
      case ReviewCaseType.suspiciousMessage:
        return l10n.reviewCaseTypeSuspiciousMessage;
      case ReviewCaseType.callOrVoiceNote:
        return l10n.reviewCaseTypeCallOrVoice;
      case ReviewCaseType.linkOrWebsite:
        return l10n.reviewCaseTypeLinkOrWebsite;
      case ReviewCaseType.phoneSettings:
        return l10n.reviewCaseTypePhoneSettings;
      case ReviewCaseType.other:
        return l10n.reviewCaseTypeOther;
    }
  }

  String _getRiskLevelLabel(RiskLevel level, AppLocalizations l10n) {
    switch (level) {
      case RiskLevel.high:
        return l10n.reviewRiskHigh;
      case RiskLevel.medium:
        return l10n.reviewRiskMedium;
      case RiskLevel.low:
        return l10n.reviewRiskLow;
    }
  }
}
