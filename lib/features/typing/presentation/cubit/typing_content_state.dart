part of 'typing_content_cubit.dart';

enum TypingContentStatus { initial, loading, success, failure }

class TypingContentState extends Equatable {
  final TypingContentStatus status;

  /// Ngôn ngữ đang xem/nhập nội dung.
  final TypingLanguage language;

  /// Kho đang dùng thật sự (assets + gói đã import) — để hiện tổng số.
  final TypingContentBank bank;

  /// Các gói người dùng đã import cho [language].
  final List<TypingContentPack> packs;

  /// Thông báo kết quả lần import gần nhất (hiện bằng SnackBar).
  final String? message;

  final String? errorMessage;

  const TypingContentState({
    this.status = TypingContentStatus.initial,
    this.language = TypingLanguage.english,
    this.bank = const TypingContentBank(language: TypingLanguage.english),
    this.packs = const [],
    this.message,
    this.errorMessage,
  });

  /// Số từ/đoạn đến từ assets = tổng trừ đi phần các gói đóng góp.
  int get importedWords => packs.fold(0, (sum, p) => sum + p.words.length);
  int get importedParagraphs =>
      packs.fold(0, (sum, p) => sum + p.paragraphs.length);

  TypingContentState copyWith({
    TypingContentStatus? status,
    TypingLanguage? language,
    TypingContentBank? bank,
    List<TypingContentPack>? packs,
    String? message,
    String? errorMessage,
  }) {
    return TypingContentState(
      status: status ?? this.status,
      language: language ?? this.language,
      bank: bank ?? this.bank,
      packs: packs ?? this.packs,
      message: message,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, language, bank, packs, message, errorMessage];
}
