import 'package:flutter/material.dart';
import 'package:persalone/l10n/app_localizations.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/review_case.dart';
import 'review_summary_page.dart';

/// Page for creating a new review case
class ReviewPage extends StatefulWidget {
  static const String routeName = '/review';

  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  ReviewCaseType _selectedCaseType = ReviewCaseType.suspiciousMessage;
  final TextEditingController _titleController = TextEditingController();
  RiskLevel _selectedRiskLevel = RiskLevel.medium;
  final TextEditingController _decisionController = TextEditingController();

  // Default checklist items with their checked state
  final List<ChecklistItemResult> _checklistItems = [];

  @override
  void initState() {
    super.initState();
    _initializeChecklistItems();
  }

  void _initializeChecklistItems() {
    // Default checklist items (will be localized)
    _checklistItems.addAll([
      ChecklistItemResult(
        id: 'sender_verified',
        label: '¿El remitente es quien dice ser?',
        isChecked: false,
      ),
      ChecklistItemResult(
        id: 'official_domain',
        label: '¿El enlace lleva a un dominio oficial?',
        isChecked: false,
      ),
      ChecklistItemResult(
        id: 'personal_data_requested',
        label: '¿Me piden datos personales o bancarios?',
        isChecked: false,
      ),
      ChecklistItemResult(
        id: 'urgent_language',
        label: '¿Usa lenguaje urgente o alarmista?',
        isChecked: false,
      ),
      ChecklistItemResult(
        id: 'grammar_errors',
        label: '¿Tiene errores graves de ortografía?',
        isChecked: false,
      ),
    ]);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _decisionController.dispose();
    super.dispose();
  }

  void _saveReview() {
    // Generate unique ID
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    // Create review case
    final reviewCase = ReviewCase(
      id: id,
      createdAt: DateTime.now(),
      caseType: _selectedCaseType,
      title: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
      checklistItems: _checklistItems,
      riskLevel: _selectedRiskLevel,
      decisionNote: _decisionController.text.trim(),
    );

    // Save to repository
    ServiceLocator().reviewsRepository.addCase(reviewCase);

    // Navigate to summary page
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ReviewSummaryPage(reviewCase: reviewCase),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reviewNewTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Metadata
            Text(
              l10n.reviewWhatToReview,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Case type dropdown
            DropdownButtonFormField<ReviewCaseType>(
              value: _selectedCaseType,
              decoration: InputDecoration(
                labelText: l10n.reviewCaseType,
                border: const OutlineInputBorder(),
              ),
              items: ReviewCaseType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getCaseTypeLabel(type, l10n)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCaseType = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            // Optional title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.reviewOptionalTitle,
                hintText: l10n.reviewTitleHint,
                border: const OutlineInputBorder(),
              ),
              maxLength: 100,
            ),

            const SizedBox(height: 32),

            // Section 2: Checklist
            Text(
              l10n.reviewSignalsReviewed,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.reviewChecklistHelp,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: _checklistItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    return CheckboxListTile(
                      title: Text(item.label),
                      value: item.isChecked,
                      onChanged: (value) {
                        setState(() {
                          _checklistItems[index] = item.copyWith(isChecked: value ?? false);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Section 3: Risk and decision
            Text(
              l10n.reviewRiskAndDecision,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Risk level selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.reviewHowDoYouSeeRisk,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<RiskLevel>(
                      segments: [
                        ButtonSegment(
                          value: RiskLevel.low,
                          label: Text(l10n.reviewRiskLow),
                          icon: const Icon(Icons.check_circle, size: 18),
                        ),
                        ButtonSegment(
                          value: RiskLevel.medium,
                          label: Text(l10n.reviewRiskMedium),
                          icon: const Icon(Icons.info, size: 18),
                        ),
                        ButtonSegment(
                          value: RiskLevel.high,
                          label: Text(l10n.reviewRiskHigh),
                          icon: const Icon(Icons.warning, size: 18),
                        ),
                      ],
                      selected: {_selectedRiskLevel},
                      onSelectionChanged: (Set<RiskLevel> selected) {
                        setState(() {
                          _selectedRiskLevel = selected.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Decision note
            TextField(
              controller: _decisionController,
              decoration: InputDecoration(
                labelText: l10n.reviewWhatDidYouDecide,
                hintText: l10n.reviewDecisionHint,
                helperText: l10n.reviewDecisionHelperText,
                helperMaxLines: 2,
                border: const OutlineInputBorder(),
              ),
              maxLines: 5,
              maxLength: 500,
            ),

            const SizedBox(height: 32),

            // Save button
            PrimaryButton(
              label: l10n.reviewSaveReview,
              onPressed: _saveReview,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
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
