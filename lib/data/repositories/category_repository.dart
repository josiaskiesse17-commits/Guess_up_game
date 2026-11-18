import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/category.dart';
import '../models/word.dart';

/// Loads and provides access to bundled category and word data.
///
/// Data is bundled locally (offline-first). Invalid or missing asset data is
/// surfaced as a clear error so the app can handle it safely at startup.
class CategoryRepository {
  final List<Category> _categories = [];
  bool _loaded = false;

  /// Loads categories from the bundled JSON asset at runtime.
  CategoryRepository();

  /// For testing: inject categories directly without asset loading.
  CategoryRepository.withData(List<Category> categories) {
    _categories.addAll(categories);
    _validate();
    _loaded = true;
  }

  /// All loaded categories (unmodifiable view).
  List<Category> get categories => List.unmodifiable(_categories);

  /// Whether data has been loaded successfully.
  bool get isLoaded => _loaded;

  /// Load categories from the bundled JSON asset.
  ///
  /// Missing or malformed asset data is surfaced as a clear error so the
  /// application can handle it safely at startup instead of crashing.
  Future<void> load({String assetPath = 'assets/data/categories.json'}) async {
    if (_loaded) return;
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final list = data['categories'] as List<dynamic>;
      _categories
        ..clear()
        ..addAll(list.map((e) => _parseCategory(e as Map<String, dynamic>)));
      _validate();
      _loaded = true;
    } on FormatException catch (e) {
      throw StateError('Invalid category data format in $assetPath: $e');
    } on StateError {
      rethrow;
    } catch (e) {
      throw StateError('Failed to load category data from $assetPath: $e');
    }
  }

  Category _parseCategory(Map<String, dynamic> json) {
    final words = (json['words'] as List<dynamic>)
        .map((w) => Word(id: w['id'] as String, text: w['text'] as String))
        .toList();
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '',
      words: words,
    );
  }

  void _validate() {
    final ids = <String>{};
    for (final cat in _categories) {
      if (ids.contains(cat.id)) {
        throw StateError('Duplicate category id: ${cat.id}');
      }
      ids.add(cat.id);
      final wordIds = <String>{};
      for (final word in cat.words) {
        if (wordIds.contains(word.id)) {
          throw StateError(
            'Duplicate word id in category ${cat.id}: ${word.id}',
          );
        }
        wordIds.add(word.id);
        if (word.text.trim().isEmpty) {
          throw StateError('Empty word text in category ${cat.id}');
        }
      }
    }
  }

  /// Find a category by its stable id. Returns null when not found.
  Category? findById(String id) {
    for (final c in _categories) {
      if (c.id == id) return c;
    }
    return null;
  }
}
