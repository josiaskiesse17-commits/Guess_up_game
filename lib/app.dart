import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/placeholder_screens.dart';

/// Application root.
///
/// Defines the named navigation routes between screens. Real screen UI is
/// implemented in Milestone 2; placeholder screens keep navigation functional
/// and the application runnable in the meantime.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: appTheme,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.categorySelection: (context) =>
            const CategorySelectionScreen(),
        AppRoutes.roundSettings: (context) => const RoundSettingsScreen(),
        AppRoutes.gameplay: (context) => const GameplayScreen(),
        AppRoutes.results: (context) => const ResultsScreen(),
      },
    );
  }
}
