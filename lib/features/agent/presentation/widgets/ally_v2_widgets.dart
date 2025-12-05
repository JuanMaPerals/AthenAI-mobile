// lib/features/agent/presentation/widgets/ally_v2_widgets.dart

import 'package:flutter/material.dart';
import '../../domain/ally_message_response_v2.dart';
import 'package:persalone/l10n/app_localizations.dart';

/// Risk badge showing classification level with icon and color
class RiskBadge extends StatelessWidget {
  final String riskLevel;
  final String typeLabel;

  const RiskBadge({
    super.key,
    required this.riskLevel,
    required this.typeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    Color backgroundColor;
    Color foregroundColor;
    IconData icon;
    String label;

    switch (riskLevel) {
      case 'high':
        backgroundColor = theme.colorScheme.error;
        foregroundColor = theme.colorScheme.onError;
        icon = Icons.warning;
        label = l10n.allyRiskHigh;
        break;
      case 'medium':
        backgroundColor = Colors.orange;
        foregroundColor = Colors.white;
        icon = Icons.info_outline;
        label = l10n.allyRiskMedium;
        break;
      case 'low':
      default:
        backgroundColor = Colors.green.shade700;
        foregroundColor = Colors.white;
        icon = Icons.check_circle_outline;
        label = l10n.allyRiskLow;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foregroundColor, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '$label: $typeLabel',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Panel showing extracted data (URLs, amounts, entities)
class AnalysisPanel extends StatelessWidget {
  final AllyExtractedData extractedData;

  const AnalysisPanel({super.key, required this.extractedData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final hasData = extractedData.urls.isNotEmpty ||
        extractedData.amounts.isNotEmpty ||
        extractedData.entities.isNotEmpty;

    if (!hasData) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.allyDetectedSectionTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // URLs
            if (extractedData.urls.isNotEmpty) ...[
              _buildSectionLabel(context, l10n.allyDetectedUrls),
              ...extractedData.urls.map((url) => _buildUrlItem(context, url)),
              const SizedBox(height: 8),
            ],

            // Amounts
            if (extractedData.amounts.isNotEmpty) ...[
              _buildSectionLabel(context, l10n.allyDetectedAmounts),
              ...extractedData.amounts.map((amount) => _buildAmountItem(context, amount)),
              const SizedBox(height: 8),
            ],

            // Entities
            if (extractedData.entities.isNotEmpty) ...[
              _buildSectionLabel(context, l10n.allyDetectedEntities),
              ...extractedData.entities.map((entity) => _buildEntityItem(context, entity)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
      ),
    );
  }

  Widget _buildUrlItem(BuildContext context, ExtractedUrl url) {
    final theme = Theme.of(context);
    final isSuspicious = url.suspicious;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSuspicious ? Colors.red.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSuspicious ? Colors.red.shade300 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSuspicious ? Icons.warning : Icons.link,
            size: 20,
            color: isSuspicious ? Colors.red.shade700 : Colors.grey.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  url.domain,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSuspicious ? Colors.red.shade900 : null,
                  ),
                ),
                if (url.suspiciousReason != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    url.suspiciousReason!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountItem(BuildContext context, ExtractedAmount amount) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.euro, size: 20, color: Colors.amber.shade900),
          const SizedBox(width: 12),
          Text(
            amount.formatted,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntityItem(BuildContext context, ExtractedEntity entity) {
    final theme = Theme.of(context);
    final isLegitimate = entity.legitimate;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isLegitimate ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        entity.text,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

/// List of recommended actions as numbered steps
class ActionList extends StatelessWidget {
  final List<AllyRecommendedAction> actions;

  const ActionList({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.allyActionsSectionTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...actions.asMap().entries.map((entry) {
              final index = entry.key;
              final action = entry.value;
              return ActionCard(
                action: action,
                stepNumber: index + 1,
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Individual action card with icon and description
class ActionCard extends StatelessWidget {
  final AllyRecommendedAction action;
  final int stepNumber;

  const ActionCard({
    super.key,
    required this.action,
    required this.stepNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final icon = _getIconData(action.icon);
    final isUrgent = action.urgent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUrgent ? Colors.red.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUrgent ? Colors.red.shade300 : Colors.grey.shade300,
          width: isUrgent ? 2 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number circle
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isUrgent ? theme.colorScheme.error : theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20, color: isUrgent ? Colors.red.shade700 : Colors.grey.shade700),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        action.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  action.description,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData? _getIconData(String? iconName) {
    switch (iconName) {
      case 'block':
        return Icons.block;
      case 'verify':
        return Icons.verified_user;
      case 'contact':
        return Icons.phone;
      case 'delete':
        return Icons.delete;
      case 'check':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'info':
        return Icons.info;
      default:
        return null;
    }
  }
}

/// Conditional guidance section (if/then scenarios)
class ConditionalGuidancePanel extends StatelessWidget {
  final List<ConditionalGuidance> guidance;

  const ConditionalGuidancePanel({super.key, required this.guidance});

  @override
  Widget build(BuildContext context) {
    if (guidance.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.allyConditionalGuidanceTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...guidance.map((item) => _buildGuidanceItem(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidanceItem(BuildContext context, ConditionalGuidance item) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, size: 20, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.condition,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.action,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
