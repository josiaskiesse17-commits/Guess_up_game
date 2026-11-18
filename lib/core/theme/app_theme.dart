import 'package:flutter/material.dart';

/// Primary seed color — a warm terracotta that feels energetic and playful.
const Color _seedColor = Color(0xFF6D4C41);

/// Secondary accent — a vibrant teal for highlights and selected states.
const Color _secondaryColor = Color(0xFF00ACC1);

/// Surface color for cards and containers.
const Color _surfaceColor = Color(0xFFF9F5F0);

/// Error/danger color for disabled states.
const Color _errorColor = Color(0xFFD32F2F);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.light,
    secondary: _secondaryColor,
    surface: _surfaceColor,
    error: _errorColor,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w900,
      letterSpacing: -1.2,
    ),
    displayMedium: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.8,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 56),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, 56),
      padding: const EdgeInsets.symmetric(vertical: 16),
      side: BorderSide(color: _seedColor, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: EdgeInsets.zero,
    color: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _surfaceColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
);

/// Returns a playful emoji icon for the given category id.
IconData categoryIcon(String id) {
  switch (id) {
    case 'movies-tv':
      return Icons.movie;
    case 'video-games':
      return Icons.videogame_asset;
    case 'animals':
      return Icons.pets;
    case 'sports':
      return Icons.sports;
    case 'celebrities':
      return Icons.person;
    case 'music':
      return Icons.music_note;
    case 'geography':
      return Icons.map;
    case 'science':
      return Icons.science;
    case 'technology':
      return Icons.computer;
    case 'food-drinks':
      return Icons.restaurant;
    case 'history':
      return Icons.history;
    case 'anime-manga':
      return Icons.tv;
    case 'african-culture':
      return Icons.explore;
    case 'general-knowledge':
      return Icons.school;
    case 'programming':
      return Icons.code;
    case 'vehicles':
      return Icons.directions_car;
    case 'superheroes':
      return Icons.sentiment_very_satisfied;
    case 'professions':
      return Icons.work;
    case 'everyday-objects':
      return Icons.home;
    case 'expressions-slang':
      return Icons.chat;
    default:
      return Icons.label;
  }
}

/// Returns a display color for a category card based on its id.
Color categoryColor(String id) {
  switch (id) {
    case 'movies-tv':
      return const Color(0xFF7B1FA2);
    case 'video-games':
      return const Color(0xFF1E88E5);
    case 'animals':
      return const Color(0xFF43A047);
    case 'sports':
      return const Color(0xFFFB8C00);
    case 'celebrities':
      return const Color(0xFFD81B60);
    case 'music':
      return const Color(0xFF8E24AA);
    case 'geography':
      return const Color(0xFF1565C0);
    case 'science':
      return const Color(0xFF00796B);
    case 'technology':
      return const Color(0xFF5E35B1);
    case 'food-drinks':
      return const Color(0xFF6D4C41);
    case 'history':
      return const Color(0xFFBF360C);
    case 'anime-manga':
      return const Color(0xFFC2185B);
    case 'african-culture':
      return const Color(0xFF00695C);
    case 'general-knowledge':
      return const Color(0xFF303F9F);
    case 'programming':
      return const Color(0xFF000000);
    case 'vehicles':
      return const Color(0xFF0277BD);
    case 'superheroes':
      return const Color(0xFFE53935);
    case 'professions':
      return const Color(0xFF546E7A);
    case 'everyday-objects':
      return const Color(0xFF6D4C41);
    case 'expressions-slang':
      return const Color(0xFF7E57C2);
    default:
      return _seedColor;
  }
}
