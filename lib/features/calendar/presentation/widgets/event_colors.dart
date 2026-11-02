import 'package:flutter/material.dart';

/// Bảng màu để phân biệt sự kiện trên lịch.
const kEventColors = <int>[
  0xFFEF5350, // đỏ
  0xFFAB47BC, // tím
  0xFF5C6BC0, // chàm
  0xFF42A5F5, // xanh dương
  0xFF26A69A, // xanh mòng két
  0xFF66BB6A, // xanh lá
  0xFFFFA726, // cam
  0xFFEC407A, // hồng
];

/// Màu chữ dễ đọc suy ra từ màu sự kiện, đặt trên nền nhạt của chính màu đó:
/// chế độ Sáng → đậm hơn, chế độ Tối → sáng hơn.
Color readableOn(Color base, Brightness brightness) => HSLColor.fromColor(base)
    .withLightness(brightness == Brightness.dark ? 0.78 : 0.34)
    .toColor();
