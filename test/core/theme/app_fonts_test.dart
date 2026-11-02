import 'package:example_app/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Đồng hồ đếm ngược không được nhảy khi đổi chữ số.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  double widthOf(String text) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontFamily: AppFonts.tabular, fontSize: 100),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }

  test('mọi chữ số của font tabular rộng bằng nhau', () async {
    final loader = FontLoader(AppFonts.tabular)
      ..addFont(rootBundle
          .load('assets/fonts/BeVietnamProTabular-ExtraBold.ttf'));
    await loader.load();

    final expected = widthOf('00:00');
    for (final digit in '123456789'.split('')) {
      expect(widthOf('$digit$digit:$digit$digit'), closeTo(expected, 0.01),
          reason: 'chữ số $digit');
    }
  });
}
