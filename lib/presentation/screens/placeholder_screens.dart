import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../presentation/widgets/app_scaffold.dart';

/// Placeholder home screen (real UI implemented in B2.1).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppConstants.appName,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppConstants.appName,
              style: appTheme.textTheme.displayLarge,
            ),
            const SizedBox(height: 24),
            const Text('Home screen — UI implemented in B2.1'),
          ],
        ),
      ),
    );
  }
}

/// Placeholder category selection screen (real UI implemented in B2.2).
class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Categories',
      body: Center(child: Text('Category selection — UI implemented in B2.2')),
    );
  }
}

/// Placeholder round settings screen (real UI implemented in B2.3).
class RoundSettingsScreen extends StatelessWidget {
  const RoundSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Round Settings',
      body: Center(child: Text('Round settings — UI implemented in B2.3')),
    );
  }
}

/// Placeholder gameplay screen (real UI implemented in B4.1).
class GameplayScreen extends StatelessWidget {
  const GameplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Gameplay',
      body: Center(child: Text('Gameplay — UI implemented in B4.1')),
    );
  }
}

/// Placeholder results screen (real UI implemented in B5.1).
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Results',
      body: Center(child: Text('Results — UI implemented in B5.1')),
    );
  }
}
