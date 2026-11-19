// Flutter SDK compatibility: Material remains the app's supported UI layer.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

/// Primary brand seed colors.
const Color _lightSeed = Color(0xFF5967E8);
const Color _darkSeed = Color(0xFF9BA5FF);

/// Secondary energy accents.
const Color _lightSecondary = Color(0xFF28B8A3);
const Color _darkSecondary = Color(0xFF62E6D0);

/// Feedback colors used on gameplay stat chips (legible in both themes).
const Color correctStatColor = Color(0xFF15803D);
const Color skipStatColor = Color(0xFFC2410C);

/// Neutral surface hierarchies.
const Color _lightBg = Color(0xFFF5F7FC);
const Color _lightCard = Color(0xFFFFFFFF);
const Color _lightOutline = Color(0xFFE2E6F3);

const Color _darkBg = Color(0xFF0B0F17);
const Color _darkCard = Color(0xFF151C28);
const Color _darkOutline = Color(0xFF252F42);

TextTheme _buildTextTheme(Color primaryText, Color secondaryText) {
  return TextTheme(
    displayLarge: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w900,
      letterSpacing: -1.2,
      color: primaryText,
    ),
    displayMedium: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
      color: primaryText,
    ),
    displaySmall: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.6,
      color: primaryText,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: primaryText,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: primaryText,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: primaryText,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: primaryText,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: secondaryText,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
      color: primaryText,
    ),
  );
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _lightSeed,
    brightness: Brightness.light,
    primary: _lightSeed,
    secondary: _lightSecondary,
    tertiary: const Color(0xFF8B5CF6),
    surface: _lightBg,
    surfaceContainerLow: _lightCard,
    surfaceContainer: const Color(0xFFEDF0F9),
    surfaceContainerHighest: const Color(0xFFE3E8F5),
    outlineVariant: _lightOutline,
    error: const Color(0xFFD32F2F),
  ),
  scaffoldBackgroundColor: _lightBg,
  textTheme: _buildTextTheme(const Color(0xFF111827), const Color(0xFF4B5563)),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Color(0xFF111827)),
    titleTextStyle: TextStyle(
      color: Color(0xFF111827),
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _lightSeed,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 56),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 0,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: _lightSeed,
      minimumSize: const Size(double.infinity, 56),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      side: const BorderSide(color: _lightOutline, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: _lightCard,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
      side: const BorderSide(color: _lightOutline, width: 1.2),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _lightCard,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: _lightOutline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: _lightOutline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: _lightSeed, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
);

final ThemeData darkAppTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _darkSeed,
    brightness: Brightness.dark,
    primary: _darkSeed,
    secondary: _darkSecondary,
    tertiary: const Color(0xFFB794F4),
    surface: _darkBg,
    surfaceContainerLow: _darkCard,
    surfaceContainer: const Color(0xFF1C2434),
    surfaceContainerHighest: const Color(0xFF242E42),
    outlineVariant: _darkOutline,
    error: const Color(0xFFFF8A80),
  ),
  scaffoldBackgroundColor: _darkBg,
  textTheme: _buildTextTheme(const Color(0xFFF3F4F6), const Color(0xFF9CA3AF)),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Color(0xFFF3F4F6)),
    titleTextStyle: TextStyle(
      color: Color(0xFFF3F4F6),
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _darkSeed,
      foregroundColor: const Color(0xFF0B0F17),
      minimumSize: const Size(double.infinity, 56),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 0,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: _darkSeed,
      minimumSize: const Size(double.infinity, 56),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      side: const BorderSide(color: _darkOutline, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: _darkCard,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
      side: const BorderSide(color: _darkOutline, width: 1.2),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _darkCard,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: _darkOutline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: _darkOutline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: _darkSeed, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
);

/// Returns a crisp icon for the given category id.
IconData categoryIcon(String id) {
  switch (id) {
    case 'movies-tv':
      return Icons.movie_rounded;
    case 'video-games':
      return Icons.videogame_asset_rounded;
    case 'animals':
      return Icons.pets_rounded;
    case 'sports':
      return Icons.sports_soccer_rounded;
    case 'celebrities':
      return Icons.star_rounded;
    case 'music':
      return Icons.music_note_rounded;
    case 'geography':
      return Icons.public_rounded;
    case 'science':
      return Icons.science_rounded;
    case 'technology':
      return Icons.memory_rounded;
    case 'food-drinks':
      return Icons.restaurant_rounded;
    case 'history':
      return Icons.account_balance_rounded;
    case 'anime-manga':
      return Icons.auto_awesome_rounded;
    case 'african-culture':
      return Icons.explore_rounded;
    case 'general-knowledge':
      return Icons.school_rounded;
    case 'programming':
      return Icons.terminal_rounded;
    case 'vehicles':
      return Icons.directions_car_rounded;
    case 'superheroes':
      return Icons.bolt_rounded;
    case 'professions':
      return Icons.work_rounded;
    case 'everyday-objects':
      return Icons.chair_rounded;
    case 'expressions-slang':
      return Icons.forum_rounded;
    default:
      return Icons.label_rounded;
  }
}

/// Returns a display color for a category card that stays legible in both
/// light and dark themes.
Color categoryColor(String id) {
  switch (id) {
    case 'movies-tv':
      return const Color(0xFF8E24AA);
    case 'video-games':
      return const Color(0xFF1E88E5);
    case 'animals':
      return const Color(0xFF43A047);
    case 'sports':
      return const Color(0xFFFB8C00);
    case 'celebrities':
      return const Color(0xFFD81B60);
    case 'music':
      return const Color(0xFF9C27B0);
    case 'geography':
      return const Color(0xFF039BE5);
    case 'science':
      return const Color(0xFF00897B);
    case 'technology':
      return const Color(0xFF5E35B1);
    case 'food-drinks':
      return const Color(0xFF8D6E63);
    case 'history':
      return const Color(0xFFD84315);
    case 'anime-manga':
      return const Color(0xFFE91E63);
    case 'african-culture':
      return const Color(0xFF00838F);
    case 'general-knowledge':
      return const Color(0xFF3949AB);
    case 'programming':
      return const Color(
        0xFF26A69A,
      ); // Replaced pure black for dark-mode visibility
    case 'vehicles':
      return const Color(0xFF0288D1);
    case 'superheroes':
      return const Color(0xFFE53935);
    case 'professions':
      return const Color(0xFF607D8B);
    case 'everyday-objects':
      return const Color(0xFF795548);
    case 'expressions-slang':
      return const Color(0xFF7E57C2);
    default:
      return _lightSeed;
  }
}
