import 'package:flutter/material.dart';
import 'package:persalone/l10n/app_localizations.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/review_case.dart';
import 'review_page.dart';
import 'review_summary_page.dart';

/// Main checklist page - "Centro de revisiones"
class ChecklistPage extends StatelessWidget {
  static const String routeName = '/checklist';

  const ChecklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final reviewsRepo = ServiceLocator().reviewsRepository;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checklistCenterTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top intro section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: scheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.fact_check_outlined,
                        color: scheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.checklistCenterTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.checklistCenterIntro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: l10n.checklistStartNewReview,
                    onPressed: () {
                      Navigator.of(context).pushNamed(ReviewPage.routeName);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Recent reviews section
            Text(
              l10n.checklistRecentReviews,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // List of recent reviews
            _buildRecentReviewsList(context, reviewsRepo),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentReviewsList(BuildContext context, dynamic reviewsRepo) {
    final recentCases = reviewsRepo.getRecentCases(limit: 5);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    if (recentCases.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: scheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: scheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.checklistNoReviewsYet,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.checklistNoReviewsHelp,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: recentCases.map((reviewCase) {
        return _buildReviewCaseCard(context, reviewCase);
      }).toList(),
    );
  }

  Widget _buildReviewCaseCard(BuildContext context, ReviewCase reviewCase) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    // Get risk level color and icon
    final riskColor = _getRiskColor(reviewCase.riskLevel, scheme);
    final riskIcon = _getRiskIcon(reviewCase.riskLevel);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ReviewSummaryPage(reviewCase: reviewCase),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Risk level indicator
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: riskColor.withValues(alpha: 0.15),
                ),
                child: Icon(
                  riskIcon,
                  color: riskColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              // Case info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewCase.title ?? _getCaseTypeLabel(reviewCase.caseType, l10n),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reviewCase.getShortDate(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reviewCase.getDecisionPreview(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: scheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
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
}
