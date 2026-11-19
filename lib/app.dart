// Flutter SDK compatibility: Material remains the app's supported UI layer.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'game/models/game_config.dart';
import 'game/models/game_result.dart';
import 'presentation/screens/category_selection_screen.dart';
import 'presentation/screens/gameplay_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/results_screen.dart';
import 'presentation/screens/round_settings_screen.dart';

/// Application root.
///
/// Defines named navigation routes between screens using [onGenerateRoute] so
/// that arguments (category IDs, game config) can be passed between screens.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(
            isDarkMode: _themeMode == ThemeMode.dark,
            onToggleTheme: _toggleTheme,
          ),
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
          builder: (_) =>
              RoundSettingsScreen(initialCategoryIds: categoryIds ?? const []),
          settings: settings,
        );
      case AppRoutes.gameplay:
        final config = settings.arguments as GameConfig?;
        if (config == null) return null;
        return MaterialPageRoute(
          builder: (_) => GameplayScreen(config: config),
          settings: settings,
        );
      case AppRoutes.results:
        final result = settings.arguments as GameResult?;
        if (result == null) return null;
        return MaterialPageRoute(
          builder: (_) => ResultsScreen(result: result),
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
      darkTheme: darkAppTheme,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      onGenerateRoute: _onGenerateRoute,
    );
  }
}


