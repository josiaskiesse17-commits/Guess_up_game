import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'game/models/game_config.dart';
import 'presentation/screens/category_selection_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/round_settings_screen.dart';

/// Application root.
///
/// Defines named navigation routes between screens using [onGenerateRoute] so
/// that arguments (category IDs, game config) can be passed between screens.
class App extends StatelessWidget {
  const App({super.key});

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case AppRoutes.categorySelection:
        return MaterialPageRoute(
          builder: (_) => const CategorySelectionScreen(),
          settings: settings,
        );
      case AppRoutes.roundSettings:
        final categoryIds = settings.arguments as List<String>?;
        return MaterialPageRoute(
          builder: (_) => RoundSettingsScreen(
            initialCategoryIds: categoryIds ?? const [],
          ),
          settings: settings,
        );
      case AppRoutes.gameplay:
        final config = settings.arguments as GameConfig?;
        if (config == null) return null;
        return MaterialPageRoute(
          builder: (_) => const GameplayPlaceholder(),
          settings: settings,
        );
      case AppRoutes.results:
        return MaterialPageRoute(
          builder: (_) => const ResultsPlaceholder(),
          settings: settings,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: appTheme,
      initialRoute: AppRoutes.home,
      onGenerateRoute: _onGenerateRoute,
    );
  }
}

/// Placeholder gameplay screen (real UI implemented in Milestone 4).
class GameplayPlaceholder extends StatelessWidget {
  const GameplayPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gameplay'), centerTitle: true),
      body: const Center(
        child: Text('Gameplay screen — implemented in Milestone 4'),
      ),
    );
  }
}

/// Placeholder results screen (real UI implemented in Milestone 5).
class ResultsPlaceholder extends StatelessWidget {
  const ResultsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Results'), centerTitle: true),
      body: const Center(
        child: Text('Results screen — implemented in Milestone 5'),
      ),
    );
  }
}
