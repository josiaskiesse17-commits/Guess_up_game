import 'dart:async';

// Flutter SDK compatibility: Material remains the app's supported UI layer.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/repositories/category_repository.dart';
import '../../game/controllers/game_controller.dart';
import '../../game/controllers/game_timer.dart';
import '../../game/models/game_config.dart';
import '../../game/models/game_result.dart';
import '../../game/models/game_session.dart';
import '../../game/models/session_status.dart';
import '../../game/services/pool_generator.dart';
import '../../game/services/tilt_sensor.dart';
import '../../game/services/game_audio.dart';
import '../../presentation/widgets/app_button.dart';

/// The main gameplay screen with optimized game loop and tilt feedback.
class GameplayScreen extends StatefulWidget {
  final GameConfig config;

  const GameplayScreen({super.key, required this.config});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen>
    with WidgetsBindingObserver {
  late GameController _controller;
  late CategoryRepository _repository;
  late GameAudio _audio;
  bool? _wasLandscape;
  bool _countdownVisible = true;
  bool _isPreparing = true;
  String? _preparationError;
  int _countdownValue = 3;
  Timer? _countdownTimer;
  bool _roundCompleteHandled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _repository = CategoryRepository();
    _audio = GameAudio();
    _controller = GameController(
      repository: _repository,
      poolGenerator: PoolGenerator(),
      onCorrect: () => _audio.playCorrect(),
      onSkip: () => _audio.playSkip(),
      sensor: TiltSensor(
        config: const TiltSensorConfig(
          correctThreshold: 15.0,
          skipThreshold: 15.0,
          cooldownMilliseconds: 800,
        ),
      ),
      config: widget.config,
    );

    _controller.state.addListener(_onStateChanged);
    _prepareGame();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    if (_wasLandscape != null && _wasLandscape != isLandscape) {
      _controller.recalibrateSensor();
    }
    _wasLandscape = isLandscape;
  }

  Future<void> _prepareGame() async {
    try {
      await _repository.load();
      if (!mounted) return;
      setState(() => _isPreparing = false);
      _startCountdown();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isPreparing = false;
        _preparationError = error.toString();
      });
    }
  }

  void _navigateToResults() {
    final session = _controller.session;
    final config = _controller.config;
    if (!mounted || session == null) return;
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.results,
      arguments: GameResult.fromSession(session, config),
    );
  }

  void _onStateChanged() {
    if (_roundCompleteHandled) return;
    final state = _controller.state.value;
    if (state.status == SessionStatus.completed) {
      _handleRoundComplete();
    }
  }

  void _startCountdown() {
    setState(() {
      _countdownVisible = true;
      _countdownValue = 3;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _countdownValue--);
      if (_countdownValue <= 0) {
        timer.cancel();
        setState(() => _countdownVisible = false);
        _controller.startGame();
      }
    });
  }

  void _handleRoundComplete() {
    if (_roundCompleteHandled) return;
    _roundCompleteHandled = true;
    _countdownTimer?.cancel();
    _controller.state.removeListener(_onStateChanged);
    WidgetsBinding.instance.removeObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _navigateToResults();
      _controller.dispose();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _controller.onAppPaused();
        break;
      case AppLifecycleState.resumed:
        _controller.onAppResumed();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _controller.state.removeListener(_onStateChanged);
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isPreparing) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_preparationError != null) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: colorScheme.error,
                  size: 56,
                ),
                const SizedBox(height: 16),
                Text(_preparationError!, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                AppOutlineButton(
                  label: 'Back',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            if (_countdownVisible) _buildCountdownOverlay(colorScheme),
            if (!_countdownVisible) _buildGameContent(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownOverlay(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _countdownValue > 0 ? '$_countdownValue' : 'GO!',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 120,
                fontWeight: FontWeight.w900,
                letterSpacing: -4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Get ready to tilt!',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameContent(ColorScheme colorScheme) {
    return ValueListenableBuilder<GameSessionState>(
      valueListenable: _controller.state,
      builder: (context, state, child) {
        final session = state.session;
        final timer = state.timer;
        final isLandscape =
            MediaQuery.orientationOf(context) == Orientation.landscape;

        if (isLandscape) {
          return Column(
            children: [
              _buildHeader(state, timer, colorScheme),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (session?.currentWord != null)
                              Expanded(
                                child: Center(
                                  child: _buildWordDisplay(
                                    session!.currentWord!.text,
                                    colorScheme,
                                  ),
                                ),
                              )
                            else
                              const Spacer(),
                            const SizedBox(height: 8),
                            _buildTiltInstructions(colorScheme),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 168,
                        child: Column(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: AppButton(
                                  label: 'CORRECT',
                                  onPressed: () =>
                                      _controller.registerCorrect(),
                                  enabled:
                                      state.status == SessionStatus.playing,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: AppOutlineButton(
                                  label: 'SKIP',
                                  onPressed: () => _controller.registerSkip(),
                                  enabled:
                                      state.status == SessionStatus.playing,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            _buildHeader(state, timer, colorScheme),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (session?.currentWord != null)
                        _buildWordDisplay(
                          session!.currentWord!.text,
                          colorScheme,
                        ),
                      const SizedBox(height: 32),
                      _buildTiltInstructions(colorScheme),
                    ],
                  ),
                ),
              ),
            ),
            _buildActionButtons(state),
          ],
        );
      },
    );
  }

  Widget _buildHeader(
    GameSessionState state,
    GameTimer? timer,
    ColorScheme colorScheme,
  ) {
    final session = state.session;
    final remaining = timer?.remainingSeconds ?? widget.config.durationSeconds;
    final minutes = remaining ~/ 60;
    final seconds = remaining % 60;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimerChip(minutes, seconds, colorScheme),
          _buildScoreRow(session, colorScheme),
        ],
      ),
    );
  }

  Widget _buildTimerChip(int minutes, int seconds, ColorScheme colorScheme) {
    final remaining = minutes * 60 + seconds;
    final isLow = remaining <= 10;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isLow
            ? colorScheme.error.withValues(alpha: 0.12)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLow
              ? colorScheme.error
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        '$minutes:${seconds.toString().padLeft(2, '0')}',
        style: TextStyle(
          color: isLow ? colorScheme.error : colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildScoreRow(GameSession? session, ColorScheme colorScheme) {
    return Row(
      children: [
        _buildStatChip(
          Icons.check_rounded,
          '${session?.correct ?? 0}',
          Colors.green,
          colorScheme,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          Icons.skip_next_rounded,
          '${session?.skipped ?? 0}',
          Colors.orange,
          colorScheme,
        ),
      ],
    );
  }

  Widget _buildStatChip(
    IconData icon,
    String value,
    Color color,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordDisplay(String word, ColorScheme colorScheme) {
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: isLandscape ? 16 : 48,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            word,
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
              letterSpacing: -1.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildTiltInstructions(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_downward_rounded, size: 16),
          const SizedBox(width: 4),
          const Text(
            'Tilt Down: Correct',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.arrow_upward_rounded, size: 16),
          const SizedBox(width: 4),
          const Text(
            'Tilt Up: Skip',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(GameSessionState state) {
    final isPlaying = state.status == SessionStatus.playing;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              label: 'CORRECT',
              onPressed: () => _controller.registerCorrect(),
              enabled: isPlaying,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppOutlineButton(
              label: 'SKIP',
              onPressed: () => _controller.registerSkip(),
              enabled: isPlaying,
            ),
          ),
        ],
      ),
    );
  }
}
