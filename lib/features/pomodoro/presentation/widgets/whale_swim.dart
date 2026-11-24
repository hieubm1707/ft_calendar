import 'dart:math' as math;
import 'dart:ui' show Offset, Size;

/// Thông số của ảnh `assets/mascot/52hz_swim.png`: lưới 3x3, đuôi hạ dần từ ô đầu
/// đến ô cuối, cá quay mặt sang phải. Giữ khớp với
/// `branding/tools/make_whale_sprite.py`.
abstract final class WhaleSprite {
  static const asset = 'assets/mascot/52hz_swim.png';
  static const columns = 3;
  static const frameCount = 9;
  static const cellWidth = 384.0;
  static const cellHeight = 232.0;

  /// Vị trí miệng so với tâm ô, để nhả bong bóng.
  static const mouth = Offset(150, 26);
}

/// Trạng thái của cá voi tại một thời điểm.
class WhalePose {
  final Offset center;
  final bool facingRight;

  /// Radian, dương là chúc đầu xuống. Áp dụng sau khi đã lật theo hướng bơi.
  final double tilt;

  /// Ô trong sprite, từ 0.
  final int frame;

  const WhalePose({
    required this.center,
    required this.facingRight,
    required this.tilt,
    required this.frame,
  });
}

class WhaleBubble {
  final Offset center;
  final double radius;
  final double opacity;

  const WhaleBubble({
    required this.center,
    required this.radius,
    required this.opacity,
  });
}

/// Đường bơi của cá voi trong khung [area], tính thuần theo thời gian đã trôi qua
/// nên không giữ trạng thái và đổi cỡ màn hình giữa chừng vẫn đúng.
///
/// Mỗi lượt cá bơi lượn ngang qua màn hình rồi ra hẳn ngoài mép, nghỉ một lát và
/// quay lại từ phía đối diện ở một độ cao khác. Thời gian một lượt cố định nên
/// màn hình càng rộng cá bơi càng nhanh, nhìn vẫn thong thả như nhau.
class WhaleSwim {
  final Size area;

  const WhaleSwim(this.area);

  static const passSeconds = 30.0;
  static const restSeconds = 4.0;
  static const cycleSeconds = passSeconds + restSeconds;

  /// Phát qua lại 9 ô thành vòng 16 nhịp, khoảng 1,1 giây một lần quẫy đuôi.
  static const flapFps = 14.0;
  static const flapSteps = 2 * (WhaleSprite.frameCount - 1);

  /// Độ cao mỗi lượt, tính theo tỉ lệ chiều cao màn hình.
  static const lanes = [0.58, 0.34, 0.68, 0.42, 0.62];

  static const _waveSeconds = 14.0;
  static const _maxTilt = 0.26;

  static const bubbleEverySeconds = 3.2;
  static const bubbleLifeSeconds = 2.4;
  static const _bubbleSizes = [2.5, 4.0, 3.0];

  /// Chiều cao ô sprite khi vẽ: 15% cạnh ngắn, có chặn để không quá bé trên điện
  /// thoại hay quá to trên màn hình lớn.
  double get spriteHeight => (area.shortestSide * 0.15).clamp(64.0, 160.0);

  double get spriteWidth =>
      spriteHeight * WhaleSprite.cellWidth / WhaleSprite.cellHeight;

  /// Ô sprite của nhịp đuôi tại giây [seconds].
  static int frameAt(double seconds) {
    final step = (seconds * flapFps).floor() % flapSteps;
    return step < WhaleSprite.frameCount ? step : flapSteps - step;
  }

  WhalePose poseAt(Duration elapsed) => _poseAt(_toSeconds(elapsed));

  /// Các bong bóng đang nổi, tại thời điểm [elapsed].
  List<WhaleBubble> bubblesAt(Duration elapsed) {
    final now = _toSeconds(elapsed);
    final bubbles = <WhaleBubble>[];
    final scale = spriteHeight / 64;
    final first = ((now - bubbleLifeSeconds) / bubbleEverySeconds).ceil();
    final last = (now / bubbleEverySeconds).floor();
    for (var i = math.max(first, 0); i <= last; i++) {
      final born = i * bubbleEverySeconds;
      final age = now - born;
      // Lúc đang nghỉ ngoài mép thì không nhả bong bóng.
      if (born % cycleSeconds >= passSeconds) continue;
      final pose = _poseAt(born);
      final mouth = _mouthOf(pose);
      final t = age / bubbleLifeSeconds;
      bubbles.add(
        WhaleBubble(
          center: Offset(
            mouth.dx + math.sin(age * 3 + i) * 3 * scale,
            mouth.dy - age * 12 * scale,
          ),
          radius: _bubbleSizes[i % _bubbleSizes.length] * scale,
          opacity: math.min(t * 8, 1) * (1 - t) * 0.7,
        ),
      );
    }
    return bubbles;
  }

  static double _toSeconds(Duration d) => d.inMicroseconds / 1e6;

  WhalePose _poseAt(double seconds) {
    final pass = (seconds / cycleSeconds).floor();
    final inPass = seconds - pass * cycleSeconds;
    final progress = math.min(inPass / passSeconds, 1.0);
    final facingRight = pass.isEven;

    final travel = area.width + spriteWidth;
    final x =
        -spriteWidth / 2 + travel * (facingRight ? progress : 1 - progress);

    final amplitude = spriteHeight * 0.6;
    final wave = 2 * math.pi * inPass / _waveSeconds + pass;
    final flap = 2 * math.pi * (seconds * flapFps / flapSteps);
    final y =
        area.height * lanes[pass % lanes.length] +
        amplitude * math.sin(wave) +
        spriteHeight * 0.025 * math.sin(flap);

    // Góc nghiêng theo hướng đi của đường lượn, giảm bớt cho hiền và cộng thêm
    // chút lắc theo nhịp đuôi.
    final rise = amplitude * 2 * math.pi / _waveSeconds * math.cos(wave);
    final tilt =
        (math.atan2(rise, travel / passSeconds) * 0.6).clamp(
          -_maxTilt,
          _maxTilt,
        ) +
        0.02 * math.sin(flap);

    return WhalePose(
      center: Offset(x, y),
      facingRight: facingRight,
      tilt: tilt,
      frame: frameAt(seconds),
    );
  }

  Offset _mouthOf(WhalePose pose) {
    final scale = spriteHeight / WhaleSprite.cellHeight;
    final dx = WhaleSprite.mouth.dx * scale * (pose.facingRight ? 1 : -1);
    return pose.center + Offset(dx, WhaleSprite.mouth.dy * scale);
  }
}
