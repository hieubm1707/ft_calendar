import 'dart:math' as math;

import 'package:example_app/core/theme/index.dart';
import 'package:example_app/features/tracking/presentation/widgets/tracking_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  test('accent Sáng giữ chữ trắng, accent Tối đổi sang chữ đậm', () {
    expect(AppColors.light.accent.readableForeground, Colors.white);
    expect(
      AppColors.dark.accent.readableForeground,
      AppColors.light.textPrimary,
    );
  });

  test('mọi màu mục tiêu và accent đều đạt tương phản 4.5:1', () {
    final backgrounds = [
      AppColors.light.accent,
      AppColors.dark.accent,
      for (final c in kTrackingColors) Color(c),
    ];
    for (final bg in backgrounds) {
      expect(
        _contrast(bg.readableForeground, bg),
        greaterThanOrEqualTo(4.49),
        reason: bg.toString(),
      );
    }
  });
}
