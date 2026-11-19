// Flutter SDK compatibility: Material remains the app's supported UI layer.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/category.dart';
import '../../data/repositories/category_repository.dart';
import '../../game/models/game_config.dart';
import '../../presentation/widgets/app_button.dart';
import '../../presentation/widgets/app_scaffold.dart';
import '../../presentation/widgets/duration_chip.dart';

/// The round settings screen.
///
/// Lets the player confirm their category selection and choose a round
/// duration (30, 60, 90, or 120 seconds) before starting the game.
class RoundSettingsScreen extends StatefulWidget {
  /// The IDs of categories selected on the previous screen.
  final List<String> initialCategoryIds;

  const RoundSettingsScreen({super.key, required this.initialCategoryIds});

  @override
  State<RoundSettingsScreen> createState() => _RoundSettingsScreenState();
}

class _RoundSettingsScreenState extends State<RoundSettingsScreen> {
  final CategoryRepository _repository = CategoryRepository();
  List<String> _categoryIds = [];
  int _selectedDuration = AppConstants.defaultDurationSeconds;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _categoryIds = List.unmodifiable(widget.initialCategoryIds);
    _initialize();
  }

  Future<void> _initialize() async {
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

  List<Category> get _selectedCategories {
    return _repository.categories
        .where((c) => _categoryIds.contains(c.id))
        .toList();
  }

  void _toggleDuration(int seconds) {
    setState(() {
      _selectedDuration = seconds;
    });
  }

  void _startGame() {
    if (_categoryIds.isEmpty) return;
    final config = GameConfig(
      categoryIds: List.unmodifiable(_categoryIds),
      durationSeconds: _selectedDuration,
    );
    Navigator.of(context)
        .pushReplacementNamed(AppRoutes.gameplay, arguments: config);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return AppScaffold(
        title: 'Round Settings',
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return AppScaffold(
        title: 'Round Settings',
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 56,
                  color: colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AppButton(label: 'Try Again', onPressed: _initialize),
              ],
            ),
          ),
        ),
      );
    }

    final selectedCategories = _selectedCategories;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Round Settings'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose Round Time',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Select how long the round will last.',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: AppConstants.roundDurations.map((seconds) {
                          return DurationChip(
                            seconds: seconds,
                            isSelected: _selectedDuration == seconds,
                            onTap: () => _toggleDuration(seconds),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_selectedDuration ~/ 60 == 1 ? '1 minute' : '$_selectedDuration seconds'} per round',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Selected Categories Card Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Selected Categories',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${selectedCategories.length} active',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 84,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedCategories.length,
                          itemBuilder: (context, index) {
                            final category = selectedCategories[index];
                            final catColor = categoryColor(category.id);
                            return Container(
                              width: 110,
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    categoryIcon(category.id),
                                    color: catColor,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    category.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: colorScheme.onSurface,
                                        ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: AppButton(
              label: 'START GAME',
              prominent: true,
              onPressed: _startGame,
            ),
          ),
        ),
      ),
    );
  }
}
