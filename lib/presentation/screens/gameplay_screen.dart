import 'dart:async';

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
import '../../presentation/widgets/app_button.dart';

/// The main gameplay screen.
///
/// Displays the current word prominently, countdown timer, score and skipped
/// word count, tilt instructions, and on-screen Correct/Skip fallback buttons.
/// Coordinates with [GameController] for session, timer, and sensor lifecycle.
class GameplayScreen extends StatefulWidget {
  final GameConfig config;

  const GameplayScreen({super.key, required this.config});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen>
    with WidgetsBindingObserver {
  late GameController _controller;
  bool _countdownVisible = true;
  int _countdownValue = 3;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final repository = CategoryRepository();
    _controller = GameController(
      repository: repository,
      poolGenerator: PoolGenerator(),
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

    _startCountdown();
  }

  void _onStateChanged() {
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
      setState(() {
        _countdownValue--;
      });
      if (_countdownValue <= 0) {
        timer.cancel();
        setState(() {
          _countdownVisible = false;
        });
        _controller.startGame();
      }
    });
  }

  void _handleRoundComplete() {
    _countdownTimer?.cancel();
    _controller.state.removeListener(_onStateChanged);
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        final session = _controller.session;
        final config = _controller.config;
        if (session != null) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.results,
            arguments: GameResult.fromSession(session, config),
          );
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _controller.onAppPaused();
        break;
      case AppLifecycleState.resumed:
        _controller.onAppResumed();
        break;
      case AppLifecycleState.inactive:
        _controller.onAppPaused();
        break;
      case AppLifecycleState.detached:
        _controller.onAppPaused();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.85),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                ],
              ),
            ),
          ),

          if (_countdownVisible) _buildCountdownOverlay(),

          if (!_countdownVisible) _buildGameContent(),
        ],
      ),
    );
  }

  Widget _buildCountdownOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _countdownValue > 0 ? '$_countdownValue' : 'GO!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 120,
                fontWeight: FontWeight.w900,
                letterSpacing: -4,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Get ready!',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameContent() {
    return ValueListenableBuilder<GameSessionState>(
      valueListenable: _controller.state,
      builder: (context, state, child) {
        final session = state.session;
        final timer = state.timer;

        return Column(
          children: [
            _buildHeader(state, timer),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (session?.currentWord != null)
                      _buildWordDisplay(session!.currentWord!.text),
                    const SizedBox(height: 40),
                    _buildTiltInstructions(),
                  ],
                ),
              ),
            ),
            _buildActionButtons(state),
          ],
        );
      },
    );
  }

  Widget _buildHeader(GameSessionState state, GameTimer? timer) {
    final session = state.session;
    final remaining = timer?.remainingSeconds ?? widget.config.durationSeconds;
    final minutes = remaining ~/ 60;
    final seconds = remaining % 60;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimerChip(minutes, seconds),
              _buildScoreRow(session),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerChip(int minutes, int seconds) {
    final remaining = minutes * 60 + seconds;
    final isLow = remaining <= 10;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isLow ? 0.3 : 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLow
              ? Colors.redAccent.withOpacity(0.8)
              : Colors.white.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        style: TextStyle(
          color: isLow ? Colors.redAccent : Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
        ),
        child: Text(
          '$minutes:${seconds.toString().padLeft(2, '0')}',
        ),
      ),
    );
  }

  Widget _buildScoreRow(GameSession? session) {
    return Row(
      children: [
        _buildStatChip(
          Icons.check_circle,
          '${session?.correct ?? 0}',
          Colors.greenAccent,
        ),
        const SizedBox(width: 12),
        _buildStatChip(
          Icons.skip_next,
          '${session?.skipped ?? 0}',
          Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordDisplay(String word) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        word,
        style: const TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w800,
          color: Color(0xFF6D4C41),
          letterSpacing: -2,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.fade,
      ),
    );
  }

  Widget _buildTiltInstructions() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Tilt down = Correct',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 24),
              const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Tilt up = Skip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Return to neutral between answers',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(GameSessionState state) {
    final isPlaying = state.status == SessionStatus.playing;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              label: 'Correct',
              onPressed: () => _controller.registerCorrect(),
              enabled: isPlaying,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppOutlineButton(
              label: 'Skip',
              onPressed: () => _controller.registerSkip(),
              enabled: isPlaying,
            ),
          ),
        ],
      ),
    );
  }
}
