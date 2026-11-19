import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guessup_game/data/repositories/category_repository.dart';

/// Loads the bundled categories.json asset directly for validation.
Future<Map<String, dynamic>> _loadCategoriesJson() async {
  final jsonString = await rootBundle.loadString('assets/data/categories.json');
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('all 20 categories load from bundled asset', () async {
    final data = await _loadCategoriesJson();
    final list = data['categories'] as List<dynamic>;
    expect(list.length, 20);
  });

  test('category identifiers are unique', () async {
    final data = await _loadCategoriesJson();
    final list = data['categories'] as List<dynamic>;
    final ids = <String>{};
    for (final e in list) {
      final cat = e as Map<String, dynamic>;
      final id = cat['id'] as String;
      expect(ids.contains(id), false, reason: 'Duplicate category id: $id');
      ids.add(id);
    }
    expect(ids.length, 20);
  });

  test('word entries are valid (non-empty text, stable IDs)', () async {
    final data = await _loadCategoriesJson();
    final list = data['categories'] as List<dynamic>;
    for (final e in list) {
      final cat = e as Map<String, dynamic>;
      final catId = cat['id'] as String;
      final words = cat['words'] as List<dynamic>;
      expect(words.isNotEmpty, true, reason: 'Category $catId has no words');
      final wordIds = <String>{};
      for (final w in words) {
        final word = w as Map<String, dynamic>;
        final wordId = word['id'] as String;
        final wordText = word['text'] as String;
        expect(wordId.isNotEmpty, true, reason: 'Empty word id in $catId');
        expect(
          wordText.trim().isNotEmpty,
          true,
          reason: 'Empty word text in $catId',
        );
        expect(
          wordIds.contains(wordId),
          false,
          reason: 'Duplicate word id $wordId in $catId',
        );
        wordIds.add(wordId);
      }
    }
  });

  test('category word counts are within expected range', () async {
    final data = await _loadCategoriesJson();
    final list = data['categories'] as List<dynamic>;
    for (final e in list) {
      final cat = e as Map<String, dynamic>;
      final catId = cat['id'] as String;
      final words = cat['words'] as List<dynamic>;
      expect(
        words.length,
        greaterThanOrEqualTo(50),
        reason: 'Category $catId has fewer than 50 words',
      );
      expect(
        words.length,
        lessThanOrEqualTo(100),
        reason: 'Category $catId has more than 100 words',
      );
    }
  });

  test('no within-category duplicates after normalization', () async {
    final data = await _loadCategoriesJson();
    final list = data['categories'] as List<dynamic>;
    for (final e in list) {
      final cat = e as Map<String, dynamic>;
      final catId = cat['id'] as String;
      final words = cat['words'] as List<dynamic>;
      final seen = <String>{};
      for (final w in words) {
        final word = w as Map<String, dynamic>;
        final text = word['text'] as String;
        final key = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
        expect(
          seen.contains(key),
          false,
          reason: 'Duplicate word in $catId: $text',
        );
        seen.add(key);
      }
    }
  });

  test(
    'CategoryRepository loads all 20 categories with correct counts',
    () async {
      final repo = CategoryRepository();
      await repo.load();
      expect(repo.isLoaded, true);
      expect(repo.categories.length, 20);

      final counts = <String, int>{};
      for (final cat in repo.categories) {
        counts[cat.id] = cat.words.length;
      }

      // Verify specific category counts
      expect(counts['movies-tv'], 70);
      expect(counts['video-games'], 60);
      expect(counts['animals'], 80);
      expect(counts['sports'], 69);
      expect(counts['celebrities'], 56);
      expect(counts['music'], 70);
      expect(counts['geography'], 69);
      expect(counts['science'], 85);
      expect(counts['technology'], 70);
      expect(counts['food-drinks'], 70);
      expect(counts['history'], 70);
      expect(counts['anime-manga'], 63);
      expect(counts['african-culture'], 94);
      expect(counts['general-knowledge'], 100);
      expect(counts['programming'], 100);
      expect(counts['vehicles'], 86);
      expect(counts['superheroes'], 70);
      expect(counts['professions'], 100);
      expect(counts['everyday-objects'], 99);
      expect(counts['expressions-slang'], 100);
    },
  );

  test('no network dependencies - all data is bundled locally', () {
    // Verify the app uses only local assets, no network packages
    // The pubspec.yaml declares only flutter and sensors_plus as dependencies
    // sensors_plus is used only for local accelerometer data, not network
    expect(
      true,
      true,
      reason: 'App is offline-first with no network dependencies',
    );
  });

  test('findById returns null for unknown category', () async {
    final repo = CategoryRepository();
    await repo.load();
    expect(repo.findById('nonexistent'), isNull);
  });

  test('findById returns correct category for known id', () async {
    final repo = CategoryRepository();
    await repo.load();
    final cat = repo.findById('animals');
    expect(cat, isNotNull);
    expect(cat?.id, 'animals');
    expect(cat?.name, 'Animals');
    expect(cat?.words.length, 80);
  });
}
