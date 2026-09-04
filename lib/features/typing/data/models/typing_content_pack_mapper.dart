import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/database/drift/index.dart';
import '../../domain/index.dart';

/// Danh sách chuỗi lưu trong 1 cột TEXT dạng JSON — gói nội dung luôn được
/// đọc/ghi trọn vẹn nên không cần bảng con.
List<String> _decodeList(String source) {
  try {
    final decoded = json.decode(source);
    if (decoded is! List) return const [];
    return [
      for (final item in decoded)
        if (item is String && item.isNotEmpty) item,
    ];
  } on FormatException {
    return const [];
  }
}

extension TypingContentPackRowMapper on TypingContentPackTableData {
  TypingContentPack toEntity() => TypingContentPack(
        id: id,
        name: name,
        language: TypingLanguage.fromCode(language),
        words: _decodeList(wordsJson),
        paragraphs: _decodeList(paragraphsJson),
        addedAt: addedAt,
      );
}

extension TypingContentPackEntityMapper on TypingContentPack {
  TypingContentPackTableCompanion toInsertCompanion() =>
      TypingContentPackTableCompanion.insert(
        name: name,
        language: language.code,
        wordsJson: Value(json.encode(words)),
        paragraphsJson: Value(json.encode(paragraphs)),
        addedAt: addedAt,
      );
}
