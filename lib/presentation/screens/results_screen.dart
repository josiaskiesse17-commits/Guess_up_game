import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../game/models/game_config.dart';
import '../../game/models/game_result.dart';
import '../../presentation/widgets/app_button.dart';
import 'home_screen.dart';

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
    final primary = colorScheme.primary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primary,
              primary.withOpacity(0.85),
              primary.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Header
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Round Complete',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Great job!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const Spacer(flex: 1),

              // Results card
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),

                      // Score summary
                      _buildScoreCard(context),

                      const SizedBox(height: 32),

                      // Details row
                      _buildDetailsRow(context),

                      const SizedBox(height: 40),

                      // Actions
                      _buildActions(context),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
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
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Big score number
          Text(
            '${result.correct}',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: Color(0xFF6D4C41),
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Correct Answers',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Accuracy divider
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDetailItem(
                '${result.skipped}',
                'Skipped',
                Icons.skip_next,
                Colors.orange,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade200,
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
              _buildDetailItem(
                '${result.durationSeconds}s',
                'Duration',
                Icons.access_time,
                Colors.blue,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Accuracy percentage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  percent >= 70 ? Icons.trending_up : Icons.trending_down,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '$percent% accuracy',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 16,
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

  Widget _buildDetailItem(String value, String label, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6D4C41),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          _buildDetailRow(
            context,
            'Correct',
            '${result.correct}',
            '${result.durationSeconds / 60 == 1 ? '1 minute' : '${result.durationSeconds} seconds'}',
          ),
          _buildDetailRow(
            context,
            'Skipped',
            '${result.skipped}',
            '${result.categoryIds.length} category'
            '${result.categoryIds.length == 1 ? '' : 'ies'}',
          ),
          _buildDetailRow(
            context,
            'Total Answered',
            '${result.answeredCount}',
            'Out of available words',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF6D4C41),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        AppButton(
          label: 'Play Again',
          onPressed: () {
            final config = GameConfig(
              categoryIds: List.unmodifiable(result.categoryIds),
              durationSeconds: result.durationSeconds,
            );
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.gameplay,
              arguments: config,
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.categorySelection,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: const Size(double.infinity, 52),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Change Categories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ),
              (route) => false,
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey.shade600,
            minimumSize: const Size(double.infinity, 52),
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Return to Home',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
