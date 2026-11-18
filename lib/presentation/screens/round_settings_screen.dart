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
    Navigator.of(context).pushNamed(AppRoutes.gameplay, arguments: config);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const AppScaffold(
        title: 'Round Settings',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return AppScaffold(
        title: 'Round Settings',
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Failed to load settings'),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final selectedCategories = _selectedCategories;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Round Settings'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected categories section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${selectedCategories.length} selected',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 76,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      itemCount: selectedCategories.length,
                      itemBuilder: (context, index) {
                        final category = selectedCategories[index];
                        return Container(
                          width: 116,
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary
                                  .withValues(alpha: 0.18),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                categoryIcon(category.id),
                                color: categoryColor(category.id),
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
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

            const SizedBox(height: 24),

            // Duration section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Round Duration',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: AppConstants.roundDurations.map((seconds) {
                      return DurationChip(
                        seconds: seconds,
                        isSelected: _selectedDuration == seconds,
                        onTap: () => _toggleDuration(seconds),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_selectedDuration ~/ 60 == 1 ? '1 minute' : '$_selectedDuration seconds'} per round',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Start button
            Padding(
              padding: const EdgeInsets.all(20),
              child: AppButton(label: 'Start Game', onPressed: _startGame),
            ),
          ],
        ),
      ),
    );
  }
}
