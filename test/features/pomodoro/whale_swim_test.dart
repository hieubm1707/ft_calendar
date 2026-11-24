import 'dart:ui' as ui;

import 'package:example_app/core/theme/index.dart';
import 'package:example_app/features/pomodoro/presentation/widgets/whale_swim.dart';
import 'package:example_app/features/pomodoro/presentation/widgets/whale_swimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Duration _seconds(double s) => Duration(microseconds: (s * 1e6).round());

void main() {
  const phone = Size(844, 390);
  const swim = WhaleSwim(phone);

  group('frameAt', () {
    test('phát qua lại 9 ô thành vòng 16 nhịp', () {
      final frames = [
        for (var i = 0; i < 16; i++)
          WhaleSwim.frameAt((i + 0.5) / WhaleSwim.flapFps),
      ];
      expect(frames, [0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1]);
    });

    test('lặp lại sau mỗi vòng', () {
      const period = WhaleSwim.flapSteps / WhaleSwim.flapFps;
      for (var t = 0.03; t < period; t += 0.07) {
        expect(WhaleSwim.frameAt(t + period * 5), WhaleSwim.frameAt(t));
      }
    });
  });

  group('poseAt', () {
    test('bắt đầu và kết thúc lượt đều nằm hẳn ngoài màn hình', () {
      final half = swim.spriteWidth / 2;
      expect(swim.poseAt(Duration.zero).center.dx, closeTo(-half, 0.001));
      expect(
        swim.poseAt(_seconds(WhaleSwim.passSeconds)).center.dx,
        closeTo(phone.width + half, 0.001),
      );
    });

    test('nghỉ ngoài mép giữa hai lượt', () {
      final half = swim.spriteWidth / 2;
      final resting = swim.poseAt(_seconds(WhaleSwim.passSeconds + 2));
      expect(resting.center.dx, closeTo(phone.width + half, 0.001));
    });

    test('lượt sau bơi ngược lại, từ phía đối diện', () {
      final half = swim.spriteWidth / 2;
      expect(swim.poseAt(_seconds(1)).facingRight, isTrue);
      final back = swim.poseAt(_seconds(WhaleSwim.cycleSeconds));
      expect(back.facingRight, isFalse);
      expect(back.center.dx, closeTo(phone.width + half, 0.001));
      expect(
        swim.poseAt(_seconds(WhaleSwim.cycleSeconds * 2)).facingRight,
        isTrue,
      );
    });

    test('luôn tiến về phía trước và không đi lùi', () {
      var last = double.negativeInfinity;
      for (var t = 0.0; t <= WhaleSwim.passSeconds; t += 0.5) {
        final x = swim.poseAt(_seconds(t)).center.dx;
        expect(x, greaterThanOrEqualTo(last));
        last = x;
      }
    });

    test(
      'thân cá luôn nằm trong chiều cao màn hình, góc nghiêng có giới hạn',
      () {
        for (final area in const [
          Size(844, 390),
          Size(1440, 900),
          Size(320, 240),
        ]) {
          final s = WhaleSwim(area);
          for (var t = 0.0; t < WhaleSwim.cycleSeconds * 10; t += 0.37) {
            final pose = s.poseAt(_seconds(t));
            expect(
              pose.center.dy - s.spriteHeight / 2,
              greaterThanOrEqualTo(0),
            );
            expect(
              pose.center.dy + s.spriteHeight / 2,
              lessThanOrEqualTo(area.height),
            );
            expect(pose.tilt.abs(), lessThan(0.3));
            expect(pose.frame, inInclusiveRange(0, WhaleSprite.frameCount - 1));
          }
        }
      },
    );
  });

  group('spriteHeight', () {
    test('bằng 15% cạnh ngắn trong khoảng giới hạn', () {
      expect(
        const WhaleSwim(Size(1440, 900)).spriteHeight,
        closeTo(135, 0.001),
      );
    });

    test('có chặn trên và chặn dưới', () {
      expect(const WhaleSwim(Size(320, 240)).spriteHeight, 64);
      expect(const WhaleSwim(Size(4000, 2000)).spriteHeight, 160);
    });
  });

  group('bubblesAt', () {
    test('có bong bóng khi đang bơi, độ mờ hợp lệ', () {
      final bubbles = swim.bubblesAt(
        _seconds(WhaleSwim.bubbleEverySeconds + 1),
      );
      expect(bubbles, isNotEmpty);
      for (final b in bubbles) {
        expect(b.opacity, inInclusiveRange(0.0, 1.0));
        expect(b.radius, greaterThan(0));
      }
    });

    test('bong bóng nổi dần lên', () {
      final start = _seconds(WhaleSwim.bubbleEverySeconds + 0.2);
      final later = _seconds(WhaleSwim.bubbleEverySeconds + 1.8);
      final a = swim.bubblesAt(start).last.center.dy;
      final b = swim.bubblesAt(later).last.center.dy;
      expect(b, lessThan(a));
    });

    test('không nhả bong bóng lúc đang nghỉ ngoài mép', () {
      final justBefore = WhaleSwim.cycleSeconds - 0.01;
      expect(swim.bubblesAt(_seconds(justBefore)), isEmpty);
    });
  });

  test('ảnh sprite khớp với thông số trong code', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final data = await rootBundle.load(WhaleSprite.asset);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final image = (await codec.getNextFrame()).image;
    const rows = WhaleSprite.frameCount ~/ WhaleSprite.columns;
    expect(image.width, WhaleSprite.cellWidth * WhaleSprite.columns);
    expect(image.height, WhaleSprite.cellHeight * rows);
    image.dispose();
    codec.dispose();
  });

  group('WhaleSwimmer', () {
    Future<void> pumpSwimmer(
      WidgetTester tester, {
      required bool reduce,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppColors.light]),
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: reduce),
            child: const SizedBox.expand(child: WhaleSwimmer()),
          ),
        ),
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }

    Finder painted() => find.descendant(
      of: find.byType(WhaleSwimmer),
      matching: find.byType(CustomPaint),
    );

    testWidgets('vẽ cá và không nhận thao tác chạm', (tester) async {
      await pumpSwimmer(tester, reduce: false);
      expect(painted(), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(WhaleSwimmer),
          matching: find.byType(IgnorePointer),
        ),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('bật giảm chuyển động thì không hiện cá', (tester) async {
      await pumpSwimmer(tester, reduce: true);
      expect(painted(), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });
  });
}
