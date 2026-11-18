// Flutter SDK compatibility: Material remains the app's supported UI layer.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../presentation/widgets/app_button.dart';

/// The application home screen.
///
/// Features a polished, modern dashboard layout with deep support for
/// both light and dark themes using dynamic Material 3 color schemes.
class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Ambient background glow for visual depth
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(
                    alpha: isDarkMode ? 0.12 : 0.08,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Top bar with theme toggle & status indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bolt,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'v2.4 Ready',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: onToggleTheme,
                        tooltip: isDarkMode
                            ? 'Switch to light theme'
                            : 'Switch to dark theme',
                        icon: Icon(
                          isDarkMode
                              ? Icons.wb_sunny_rounded
                              : Icons.nightlight_round,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // Hero Branding Section
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 104,
                          height: 104,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.primary,
                                colorScheme.tertiary,
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_fire_department_rounded,
                            color: Colors.white,
                            size: 52,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          AppConstants.appName,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Guess the word before time runs out!',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Feature Card Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? colorScheme.surfaceContainerHighest.withValues(
                              alpha: 0.5,
                            )
                          : colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your next challenge',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Pick your categories, set the round duration, and test your reflex instincts.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const [
                            _FeaturePill(
                              icon: Icons.category_outlined,
                              label: '20+ Categories',
                            ),
                            _FeaturePill(
                              icon: Icons.wifi_off_rounded,
                              label: 'Offline Play',
                            ),
                            _FeaturePill(
                              icon: Icons.screen_rotation_alt_rounded,
                              label: 'Tilt or Tap',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'START PLAYING',
                      prominent: true,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.categorySelection);
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeaturePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
