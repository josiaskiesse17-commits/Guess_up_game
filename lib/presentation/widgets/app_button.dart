import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// A reusable, themed primary action button.
///
/// Centralizes button styling so all screens share a consistent look.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool enabled;
  final bool prominent;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.prominent = false,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: enabled ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: appTheme.colorScheme.primary,
        foregroundColor: appTheme.colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 56),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: prominent ? 20 : 18,
          fontWeight: FontWeight.w700,
          letterSpacing: prominent ? 0.5 : 0,
        ),
      ),
    );
  }
}

/// A reusable, themed secondary (outline) action button.
class AppOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool enabled;

  const AppOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: appTheme.colorScheme.primary,
        minimumSize: const Size(double.infinity, 56),
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: appTheme.colorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
