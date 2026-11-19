import 'package:flutter_test/flutter_test.dart';

import 'package:guessup_game/core/constants/app_constants.dart';
import 'package:guessup_game/game/services/tilt_math.dart';

void main() {
  group('tiltAngleDegrees', () {
    test('vertical portrait pose has angle 0', () {
      expect(tiltAngleDegrees(0, -9.8, 0), 0.0);
    });

    test('screen facing floor has angle -90', () {
      expect(tiltAngleDegrees(0, 0, -9.8), -90.0);
    });

    test('screen facing ceiling has angle 90', () {
      expect(tiltAngleDegrees(0, 0, 9.8), 90.0);
    });

    test('in-between angle: z=-4.9 gives -30 degrees', () {
      expect(tiltAngleDegrees(0, 8.49, -4.9), closeTo(-30, 0.1));
    });

    test('zero magnitude returns 0', () {
      expect(tiltAngleDegrees(0, 0, 0), 0.0);
    });

    test('same angle regardless of in-plane axis (portrait vs landscape)', () {
      // Same screen tilt (-30°), device rotated around Z.
      final a = tiltAngleDegrees(0, 8.49, -4.9); // portrait
      final b = tiltAngleDegrees(-8.49, 0, -4.9); // landscape-left
      final c = tiltAngleDegrees(8.49, 0, -4.9); // landscape-right
      expect(a, b);
      expect(a, c);
    });
  });

  group('TiltDetector', () {
    int nowMs = 0;

    TiltDetector detector({
      double alpha = SensorConstants.smoothingAlpha,
      double correctThreshold = SensorConstants.correctThreshold,
      double skipThreshold = SensorConstants.skipThreshold,
      double returnToNeutralDegrees = SensorConstants.returnToNeutralDegrees,
      int cooldownMilliseconds = SensorConstants.cooldownMilliseconds,
      int calibrationSamples = SensorConstants.calibrationSamples,
      bool invertTilt = SensorConstants.invertTilt,
    }) => TiltDetector(
      alpha: alpha,
      correctThreshold: correctThreshold,
      skipThreshold: skipThreshold,
      returnToNeutralDegrees: returnToNeutralDegrees,
      cooldownMilliseconds: cooldownMilliseconds,
      calibrationSamples: calibrationSamples,
      invertTilt: invertTilt,
      nowMs: () => nowMs,
    );

    test('fires Correct on sustained downward tilt past threshold', () {
      final d = detector(alpha: 1.0); // no smoothing for deterministic logic
      for (var i = 0; i < 10; i++) {
        expect(d.update(0.0), isNull);
      }
      nowMs += 1000;
      expect(d.update(-40.0), TiltDetectorAction.correct);
    });

    test('fires Skip on sustained upward tilt past threshold', () {
      final d = detector(alpha: 1.0);
      for (var i = 0; i < 10; i++) {
        expect(d.update(0.0), isNull);
      }
      nowMs += 1000;
      expect(d.update(40.0), TiltDetectorAction.skip);
    });

    test('does not fire for small jitter (+/- 8 degrees)', () {
      final d = detector(alpha: 1.0);
      for (var i = 0; i < 10; i++) {
        expect(d.update(0.0), isNull);
      }
      nowMs += 1000;
      expect(d.update(8.0), isNull);
      expect(d.update(-8.0), isNull);
      expect(d.update(0.0), isNull);
    });

    test('does not fire twice without returning to neutral', () {
      final d = detector(alpha: 1.0);
      for (var i = 0; i < 10; i++) {
        expect(d.update(0.0), isNull);
      }
      nowMs += 1000;
      expect(d.update(-40.0), TiltDetectorAction.correct);
      // Still tilted down: should not fire again.
      nowMs += 1000;
      expect(d.update(-40.0), isNull);
      // Return to neutral: |0| <= 15, so awaitingNeutral clears.
      nowMs += 1000;
      expect(d.update(0.0), isNull);
      // Tilt down again: should fire.
      nowMs += 1000;
      expect(d.update(-40.0), TiltDetectorAction.correct);
    });

    test('respects cooldown using injected clock', () {
      final d = detector(alpha: 1.0, cooldownMilliseconds: 2000);
      for (var i = 0; i < 10; i++) {
        expect(d.update(0.0), isNull);
      }
      nowMs += 1000;
      expect(d.update(-40.0), TiltDetectorAction.correct); // at nowMs=1000
      // Wait past cooldown AND return to neutral (clear awaitingNeutral).
      nowMs += 2000; // nowMs = 3000, 2000ms since last action
      expect(d.update(0.0), isNull); // |0| <= 15, awaitingNeutral clears
      // Now past cooldown and neutral.
      nowMs += 1000; // nowMs = 4000
      expect(d.update(40.0), TiltDetectorAction.skip);
    });

    test('no action during calibration', () {
      final d = detector(calibrationSamples: 5);
      for (var i = 0; i < 4; i++) {
        expect(d.update(0.0), isNull);
        expect(d.isCalibrating, true);
      }
      // 5th sample completes calibration.
      expect(d.update(0.0), isNull);
      expect(d.isCalibrating, false);
    });

    test('neutral is average of first calibration samples', () {
      final d = detector(alpha: 1.0, calibrationSamples: 3);
      d.update(2.0);
      d.update(4.0);
      d.update(6.0);
      expect(d.neutralAngle, closeTo(4.0, 0.001));
    });

    test('invertTilt flips the sign of delta', () {
      final d = detector(alpha: 1.0, invertTilt: true);
      for (var i = 0; i < 10; i++) {
        expect(d.update(0.0), isNull);
      }
      nowMs += 1000;
      // With invertTilt, a downward tilt (-40) becomes positive delta,
      // so it fires Skip instead of Correct.
      expect(d.update(-40.0), TiltDetectorAction.skip);
    });

    test('smoothing reduces the effect of a single spike', () {
      final d = detector(alpha: 0.3);
      for (var i = 0; i < 10; i++) {
        expect(d.update(0.0), isNull);
      }
      nowMs += 1000;
      // A single spike to -40 with alpha=0.3 gives smoothed = -12,
      // which is below the 35° threshold.
      expect(d.update(-40.0), isNull);
    });
  });
}
