/// Nguồn nội dung của đề bài. [code] là giá trị lưu trong DB.
enum TypingMode {
  /// Từ ngẫu nhiên rút từ kho từ.
  words('words', 'Từ ngẫu nhiên'),

  /// Một đoạn văn có sẵn (có hoa, dấu câu).
  paragraph('paragraph', 'Đoạn văn');

  final String code;
  final String label;

  const TypingMode(this.code, this.label);

  static TypingMode fromCode(String code) {
    for (final m in values) {
      if (m.code == code) return m;
    }
    return words;
  }
}
