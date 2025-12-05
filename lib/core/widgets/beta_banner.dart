import 'package:flutter/material.dart';
import '../di/service_locator.dart';

/// Dismissible beta banner for agent screen
/// Shows: "Versión beta" with information about beta status
/// Once dismissed, stored in SharedPreferences and not shown again
class BetaBanner extends StatelessWidget {
  final VoidCallback onDismiss;

  const BetaBanner({
    super.key,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.secondary.withValues(alpha: 0.1),
        border: Border.all(
          color: scheme.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: scheme.secondary,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Versión beta',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Estamos mejorando PersalOne con tu ayuda. No realizamos cobros automáticos sin tu permiso claro.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.close,
              size: 20,
              color: scheme.onSurface.withValues(alpha: 0.6),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            onPressed: onDismiss,
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }

  /// Check if banner should be shown
  static bool shouldShow() {
    try {
      final storage = ServiceLocator().preferencesStorage;
      return !storage.getBetaBannerDismissed();
    } catch (e) {
      // If storage not initialized, don't show
      return false;
    }
  }

  /// Mark banner as dismissed
  static Future<void> dismiss() async {
    final storage = ServiceLocator().preferencesStorage;
    await storage.setBetaBannerDismissed(true);
  }
}
