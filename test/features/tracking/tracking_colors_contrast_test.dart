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
  test('chữ/icon trên mọi màu mục tiêu đạt tương phản 4.5:1', () {
    for (final c in kTrackingColors) {
      final bg = Color(c);
      expect(
        _contrast(bg.readableForeground, bg),
        greaterThanOrEqualTo(4.49),
        reason: bg.toString(),
      );
    }
  });
}
