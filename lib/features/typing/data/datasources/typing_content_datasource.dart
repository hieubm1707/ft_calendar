import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../domain/index.dart';

/// Thư mục asset chứa nội dung gõ, tách theo mã ngôn ngữ:
/// `assets/typing/en/…`, `assets/typing/vi/…`.
const kTypingAssetRoot = 'assets/typing';

/// Nguồn nội dung (từ + đoạn văn) để sinh đề bài.
abstract class TypingContentDataSource {
  Future<TypingContentBank> loadBank(TypingLanguage language);
}

/// Nạp nội dung từ **mọi file `.json`** trong `assets/typing/<mã ngôn ngữ>/`.
///
/// Muốn thêm từ/đoạn văn mới: thả thêm một file JSON vào đúng thư mục ngôn ngữ
/// rồi chạy lại app — KHÔNG phải sửa code. File có dạng:
/// ```json
/// { "words": ["the", "and"], "paragraphs": ["Một đoạn văn hoàn chỉnh."] }
/// ```
/// Cũng chấp nhận mảng chuỗi ở cấp cao nhất: phần tử có khoảng trắng được coi
/// là đoạn văn, còn lại là từ.
@LazySingleton(as: TypingContentDataSource)
class TypingContentAssetDataSource implements TypingContentDataSource {
  /// Kho đã nạp — nội dung asset không đổi lúc chạy nên đọc 1 lần là đủ.
  final _cache = <TypingLanguage, TypingContentBank>{};

  @override
  Future<TypingContentBank> loadBank(TypingLanguage language) async {
    final cached = _cache[language];
    if (cached != null) return cached;

    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final prefix = '$kTypingAssetRoot/${language.code}/';
      final paths = manifest
          .listAssets()
          .where((p) => p.startsWith(prefix) && p.endsWith('.json'))
          .toList()
        ..sort();

      var bank = TypingContentBank(language: language);
      for (final path in paths) {
        bank = bank.merge(_parse(language, await rootBundle.loadString(path)));
      }
      _cache[language] = bank;
      return bank;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  TypingContentBank _parse(TypingLanguage language, String source) {
    final decoded = json.decode(source);

    if (decoded is List) {
      final words = <String>[];
      final paragraphs = <String>[];
      for (final item in _strings(decoded)) {
        (item.contains(' ') ? paragraphs : words).add(item);
      }
      return TypingContentBank(
          language: language, words: words, paragraphs: paragraphs);
    }

    if (decoded is Map) {
      return TypingContentBank(
        language: language,
        words: _strings(decoded['words']),
        paragraphs: _strings(decoded['paragraphs']),
      );
    }

    return TypingContentBank(language: language);
  }

  /// Chỉ giữ chuỗi không rỗng; bỏ qua phần tử sai kiểu để 1 dòng hỏng không
  /// làm hỏng cả file.
  List<String> _strings(Object? value) {
    if (value is! List) return const [];
    return [
      for (final item in value)
        if (item is String && item.trim().isNotEmpty) item.trim(),
    ];
  }
}
