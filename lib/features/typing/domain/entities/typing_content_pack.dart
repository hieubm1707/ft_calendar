import 'package:equatable/equatable.dart';

import 'typing_language.dart';

/// Một gói nội dung do người dùng tự import (file hoặc dán tay), gộp thêm lên
/// trên kho có sẵn trong assets.
class TypingContentPack extends Equatable {
  final int? id;

  /// Tên để nhận ra gói trong danh sách (thường là tên file).
  final String name;

  final TypingLanguage language;
  final List<String> words;
  final List<String> paragraphs;
  final DateTime addedAt;

  const TypingContentPack({
    this.id,
    required this.name,
    required this.language,
    this.words = const [],
    this.paragraphs = const [],
    required this.addedAt,
  });

  bool get isEmpty => words.isEmpty && paragraphs.isEmpty;

  @override
  List<Object?> get props => [id, name, language, words, paragraphs, addedAt];
}
