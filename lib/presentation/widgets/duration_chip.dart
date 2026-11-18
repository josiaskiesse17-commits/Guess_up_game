import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// A selectable duration chip for choosing the round length.
///
/// Shows the duration in seconds with a minute label for longer options.
class DurationChip extends StatelessWidget {
  final int seconds;
  final bool isSelected;
  final VoidCallback onTap;

  const DurationChip({
    super.key,
    required this.seconds,
    required this.isSelected,
    required this.onTap,
  });

  String get _label {
    final minutes = seconds / 60;
    if (minutes == 1) return '$minutes min';
    if (minutes > 1 && minutes.truncateToDouble() == minutes) {
      return '${minutes.toInt()} min';
    }
    return '$seconds s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      selected: isSelected,
      onSelected: (_) => onTap(),
      label: Text(
        _label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: isSelected
              ? Colors.white
              : theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      selectedColor: AppConstants.defaultDurationSeconds == seconds
          ? theme.colorScheme.primary
          : theme.colorScheme.primary,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected ? theme.colorScheme.primary : Colors.grey.shade300,
        width: isSelected ? 2 : 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}
