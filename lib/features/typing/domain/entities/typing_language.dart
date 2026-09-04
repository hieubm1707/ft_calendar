/// Ngôn ngữ của bài test gõ phím. [code] cũng là tên thư mục asset chứa
/// từ/đoạn văn (`assets/typing/<code>/*.json`) và là giá trị lưu trong DB.
enum TypingLanguage {
  english('en', 'Tiếng Anh'),
  vietnamese('vi', 'Tiếng Việt');

  final String code;
  final String label;

  const TypingLanguage(this.code, this.label);

  /// Mã lạ (dữ liệu cũ/hỏng) quy về [english] thay vì ném lỗi.
  static TypingLanguage fromCode(String code) {
    for (final l in values) {
      if (l.code == code) return l;
    }
    return english;
  }
}
