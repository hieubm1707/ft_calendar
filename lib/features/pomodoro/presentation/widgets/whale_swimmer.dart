import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/index.dart';
import 'whale_swim.dart';

/// Cá voi 52Hz bơi lượn trên toàn bộ khung cha.
///
/// Chỉ để trang trí: không nhận thao tác chạm, không đọc bằng trình đọc màn hình,
/// và không hiện khi người dùng bật "giảm chuyển động". Vẽ lại mỗi khung hình mà
/// không dựng lại widget, trên lớp riêng để không kéo đồng hồ vẽ lại theo. Ticker
/// tự dừng khi trang bị che hoặc đã đóng.
class WhaleSwimmer extends StatefulWidget {
  const WhaleSwimmer({super.key});

  @override
  State<WhaleSwimmer> createState() => _WhaleSwimmerState();
}

class _WhaleSwimmerState extends State<WhaleSwimmer>
    with SingleTickerProviderStateMixin {
  final _elapsed = ValueNotifier(Duration.zero);
  late final Ticker _ticker = createTicker((e) => _elapsed.value = e);
  ui.Image? _sprite;

  @override
  void initState() {
    super.initState();
    _loadSprite();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncTicker();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _elapsed.dispose();
    _sprite?.dispose();
    super.dispose();
  }

  bool get _reduceMotion => MediaQuery.disableAnimationsOf(context);

  void _syncTicker() {
    final shouldRun = _sprite != null && !_reduceMotion;
    if (shouldRun && !_ticker.isActive) {
      _ticker.start();
    } else if (!shouldRun && _ticker.isActive) {
      _ticker.stop();
    }
  }

  Future<void> _loadSprite() async {
    try {
      final data = await rootBundle.load(WhaleSprite.asset);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      codec.dispose();
      if (!mounted) {
        frame.image.dispose();
        return;
      }
      setState(() => _sprite = frame.image);
      _syncTicker();
    } catch (e) {
      // Thiếu cá voi không được làm hỏng đồng hồ.
      debugPrint('Không nạp được sprite cá voi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sprite = _sprite;
    if (sprite == null || _reduceMotion) return const SizedBox.shrink();
    return IgnorePointer(
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _WhalePainter(
              sprite: sprite,
              elapsed: _elapsed,
              bubbleColor: context.colors.accent,
            ),
          ),
        ),
      ),
    );
  }
}

class _WhalePainter extends CustomPainter {
  final ui.Image sprite;
  final ValueListenable<Duration> elapsed;
  final Color bubbleColor;

  _WhalePainter({
    required this.sprite,
    required this.elapsed,
    required this.bubbleColor,
  }) : super(repaint: elapsed);

  static const _bubbleFill = 0.18;
  static const _bubbleStroke = 1.2;

  @override
  void paint(Canvas canvas, Size size) {
    final swim = WhaleSwim(size);
    final now = elapsed.value;
    _paintBubbles(canvas, swim.bubblesAt(now));
    _paintWhale(canvas, swim, swim.poseAt(now));
  }

  void _paintBubbles(Canvas canvas, List<WhaleBubble> bubbles) {
    final fill = Paint();
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _bubbleStroke;
    for (final b in bubbles) {
      fill.color = bubbleColor.withValues(alpha: b.opacity * _bubbleFill);
      stroke.color = bubbleColor.withValues(alpha: b.opacity);
      canvas.drawCircle(b.center, b.radius, fill);
      canvas.drawCircle(b.center, b.radius, stroke);
    }
  }

  void _paintWhale(Canvas canvas, WhaleSwim swim, WhalePose pose) {
    final col = pose.frame % WhaleSprite.columns;
    final row = pose.frame ~/ WhaleSprite.columns;
    final src = Rect.fromLTWH(
      col * WhaleSprite.cellWidth,
      row * WhaleSprite.cellHeight,
      WhaleSprite.cellWidth,
      WhaleSprite.cellHeight,
    );
    final dst = Rect.fromCenter(
      center: Offset.zero,
      width: swim.spriteWidth,
      height: swim.spriteHeight,
    );
    canvas
      ..save()
      ..translate(pose.center.dx, pose.center.dy)
      ..scale(pose.facingRight ? 1 : -1, 1)
      ..rotate(pose.tilt)
      ..drawImageRect(
        sprite,
        src,
        dst,
        Paint()..filterQuality = FilterQuality.medium,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_WhalePainter old) =>
      old.sprite != sprite ||
      old.elapsed != elapsed ||
      old.bubbleColor != bubbleColor;
}
