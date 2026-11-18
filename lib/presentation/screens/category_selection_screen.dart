// Flutter SDK compatibility: Material remains the app's supported UI layer.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/repositories/category_repository.dart';
import '../../presentation/widgets/app_button.dart';
import '../../presentation/widgets/app_scaffold.dart';
import '../../presentation/widgets/category_card.dart';

/// The category selection screen.
///
/// Displays all available categories in a grid. Players can select one or
/// more categories; the selected count is shown and the Continue button is
/// disabled until at least one category is chosen.
class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final CategoryRepository _repository = CategoryRepository();
  final Set<String> _selectedIds = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      await _repository.load();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  void _toggleCategory(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _continue() {
    Navigator.of(context)
        .pushNamed(AppRoutes.roundSettings, arguments: _selectedIds.toList());
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AppScaffold(
        title: 'Categories',
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return AppScaffold(
        title: 'Categories',
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Failed to load categories'),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              AppButton(label: 'Try Again', onPressed: _loadCategories),
            ],
          ),
        ),
      );
    }

    final categories = _repository.categories;
    final selectedCount = _selectedIds.length;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (selectedCount > 0)
            TextButton(onPressed: _continue, child: const Text('Continue')),
        ],
      ),
      body: Column(
        children: [
          // Selection counter
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Build your round',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pick one or mix categories for a surprise challenge.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.category, size: 16, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            '$selectedCount category'
                            '${selectedCount == 1 ? '' : 's'} selected',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Category grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 0.9,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedIds.contains(category.id);
                return CategoryCard(
                  category: category,
                  isSelected: isSelected,
                  onTap: () => _toggleCategory(category.id),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: selectedCount > 0
          ? Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: AppButton(label: 'Continue', onPressed: _continue),
            )
          : null,
    );
  }
}
