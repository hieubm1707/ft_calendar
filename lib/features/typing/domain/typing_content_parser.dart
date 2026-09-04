import 'dart:convert';

/// Nội dung đọc được từ một file/đoạn dán.
typedef ParsedTypingContent = ({List<String> words, List<String> paragraphs});

const ParsedTypingContent _emptyContent = (words: [], paragraphs: []);

/// Đọc nội dung người dùng import. Nhận cả JSON lẫn văn bản thuần/CSV để
/// người dùng khỏi phải nhớ đúng một định dạng.
///
/// **JSON** — object `{"words": [...], "paragraphs": [...]}` (thiếu khoá nào
/// cũng được), hoặc mảng chuỗi ở cấp cao nhất.
///
/// **Văn bản / CSV** — xử lý theo TỪNG DÒNG:
/// - dòng tách bằng dấu phẩy ra **toàn những mảnh không có khoảng trắng** →
///   danh sách **từ** (`the,and,people` và cả `the, and, people`);
/// - còn lại: cả dòng là **một đoạn văn** nếu có khoảng trắng, ngược lại là
///   một **từ**.
///
/// Nhờ vậy câu có dấu phẩy ("Mỗi buổi sáng, tôi pha cà phê.") không bị cắt đôi,
/// mà danh sách từ ngăn bằng dấu phẩy vẫn tách đúng.
///
/// Dòng rỗng và phần tử sai kiểu bị bỏ qua — một dòng hỏng không làm hỏng cả
/// file. Hàm thuần → dễ unit test.
ParsedTypingContent parseTypingContent(String source) {
  final text = source.trim();
  if (text.isEmpty) return _emptyContent;

  final asJson = _tryParseJson(text);
  if (asJson != null) return asJson;

  final words = <String>[];
  final paragraphs = <String>[];
  for (final rawLine in const LineSplitter().convert(text)) {
    final line = rawLine.trim();
    if (line.isEmpty) continue;

    final asWordList = _wordListOrNull(line);
    if (asWordList != null) {
      words.addAll(asWordList);
    } else if (line.contains(' ')) {
      paragraphs.add(line);
    } else {
      words.add(line);
    }
  }
  return (words: words, paragraphs: paragraphs);
}

/// Dòng là danh sách từ ngăn bằng dấu phẩy? Chỉ nhận khi tách ra được từ 2
/// mảnh trở lên và **mảnh nào cũng không có khoảng trắng** — nếu có mảnh chứa
/// khoảng trắng thì dấu phẩy đó là dấu câu của một câu văn, không phải dấu
/// ngăn cách. null = không phải danh sách từ.
List<String>? _wordListOrNull(String line) {
  if (!line.contains(',')) return null;
  final tokens = [
    for (final part in line.split(','))
      if (part.trim().isNotEmpty) part.trim(),
  ];
  if (tokens.length < 2) return null;
  return tokens.any((t) => t.contains(' ')) ? null : tokens;
}

/// null = không phải JSON hợp lệ (để lùi về đọc như văn bản thuần).
ParsedTypingContent? _tryParseJson(String text) {
  final Object? decoded;
  try {
    decoded = json.decode(text);
  } on FormatException {
    return null;
  }

  if (decoded is List) {
    final words = <String>[];
    final paragraphs = <String>[];
    for (final item in _strings(decoded)) {
      (item.contains(' ') ? paragraphs : words).add(item);
    }
    return (words: words, paragraphs: paragraphs);
  }

  if (decoded is Map) {
    return (
      words: _strings(decoded['words']),
      paragraphs: _strings(decoded['paragraphs']),
    );
  }

  // Số hay chuỗi trần: coi như không phải định dạng nội dung.
  return null;
}

/// Chỉ giữ chuỗi không rỗng; bỏ qua phần tử sai kiểu.
List<String> _strings(Object? value) {
  if (value is! List) return const [];
  return [
    for (final item in value)
      if (item is String && item.trim().isNotEmpty) item.trim(),
  ];
}
