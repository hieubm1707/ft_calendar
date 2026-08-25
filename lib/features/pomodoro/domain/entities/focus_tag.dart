import 'package:equatable/equatable.dart';

/// Tag tập trung có sẵn để chọn nhanh (thuần Dart).
/// [minutes] là độ dài phiên focus gợi ý khi chọn tag này.
class FocusTag extends Equatable {
  final int? id;
  final String title;
  final int minutes;

  /// Màu ARGB dùng cho chip + biểu đồ focus trend.
  final int color;

  /// Emoji hiển thị (null = không có).
  final String? emoji;

  final int sortOrder;

  const FocusTag({
    this.id,
    required this.title,
    required this.minutes,
    this.color = 0xFF00B3A6,
    this.emoji,
    this.sortOrder = 0,
  });

  FocusTag copyWith({
    int? id,
    String? title,
    int? minutes,
    int? color,
    String? emoji,
    int? sortOrder,
  }) {
    return FocusTag(
      id: id ?? this.id,
      title: title ?? this.title,
      minutes: minutes ?? this.minutes,
      color: color ?? this.color,
      emoji: emoji ?? this.emoji,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [id, title, minutes, color, emoji, sortOrder];
}
