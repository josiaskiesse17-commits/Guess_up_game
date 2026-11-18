// Flutter SDK compatibility: Material remains the app's supported UI layer.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../game/models/game_result.dart';
import '../../presentation/widgets/app_button.dart';

/// The results screen shown at the end of a round.
///
/// Displays final score, correct answers, skipped answers, and round
/// duration. Offers replay (same configuration, fresh session), return to
/// category selection, and return to home actions.
class ResultsScreen extends StatelessWidget {
  final GameResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Trophy Header Icon
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(
                        alpha: 0.6,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.emoji_events_rounded,
                      color: colorScheme.primary,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Round Complete!',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Here is how your session went',
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Main Score Card
                  _buildScoreCard(context),

                  const SizedBox(height: 24),

                  // Detailed breakdown list card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.4,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                        width: 1.2,
                      ),
                    ),
                    child: _buildDetailsRow(context),
                  ),

                  const SizedBox(height: 36),

                  // Action Buttons
                  AppButton(
                    label: 'PLAY AGAIN',
                    prominent: true,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 12),
                  AppOutlineButton(
                    label: 'CHOOSE CATEGORIES',
                    onPressed: () {
                      Navigator.of(context).popUntil(
                        ModalRoute.withName(AppRoutes.categorySelection),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final percent = result.answeredCount > 0
        ? (result.correct / result.answeredCount * 100).round()
        : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Big score number
          Text(
            '${result.correct}',
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: colorScheme.primary,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Correct Answers',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),

          // Accuracy divider row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDetailItem(
                context,
                '${result.skipped}',
                'Skipped',
                Icons.skip_next_rounded,
                Colors.orangeAccent,
              ),
              Container(
                width: 1,
                height: 44,
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              _buildDetailItem(
                context,
                '${result.durationSeconds}s',
                'Duration',
                Icons.timer_rounded,
                Colors.blueAccent,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Accuracy percentage pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  percent >= 70
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  '$percent% accuracy rate',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsRow(BuildContext context) {
    return Column(
      children: [
        _buildDetailRow(
          context,
          'Round Duration',
          '${result.durationSeconds}s',
          result.durationSeconds == 60
              ? '1 full minute'
              : '${result.durationSeconds} seconds total',
        ),
        Divider(
          color: Theme.of(context).colorScheme.outlineVariant
              .withValues(alpha: 0.3),
          height: 1,
        ),
        _buildDetailRow(
          context,
          'Categories Played',
          '${result.categoryIds.length}',
          result.categoryIds.length == 1
              ? '1 active category'
              : '${result.categoryIds.length} categories mixed',
        ),
        Divider(
          color: Theme.of(context).colorScheme.outlineVariant
              .withValues(alpha: 0.3),
          height: 1,
        ),
        _buildDetailRow(
          context,
          'Total Attempted',
          '${result.answeredCount}',
          'Correct + Skipped words',
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    String subtitle,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
