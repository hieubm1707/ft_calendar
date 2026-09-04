part of 'typing_cubit.dart';

/// Trạng thái bài test: chờ gõ → đang chạy → đã xong.
enum TypingStatus { idle, running, finished }

class TypingState extends Equatable {
  final TypingStatus status;

  final TypingLanguage language;
  final TypingMode mode;

  /// Độ dài bài test đã chọn (giây).
  final int durationSeconds;

  /// Số giây còn lại (bằng [durationSeconds] khi chưa bắt đầu).
  final int remainingSeconds;

  /// Đề bài đang hiển thị.
  final String prompt;

  /// Chuỗi người dùng đã gõ.
  final String typed;

  /// Số liệu đang chạy; khi [status] = finished là số liệu chốt của bài.
  final TypingMetrics metrics;

  /// Đang nạp kho từ/đoạn văn.
  final bool loadingContent;

  /// Kết quả hôm nay, mới nhất trước.
  final List<TypingResult> todayResults;

  final String? errorMessage;

  const TypingState({
    this.status = TypingStatus.idle,
    this.language = TypingLanguage.english,
    this.mode = TypingMode.words,
    this.durationSeconds = 60,
    this.remainingSeconds = 60,
    this.prompt = '',
    this.typed = '',
    this.metrics = const TypingMetrics(),
    this.loadingContent = false,
    this.todayResults = const [],
    this.errorMessage,
  });

  bool get isRunning => status == TypingStatus.running;
  bool get isIdle => status == TypingStatus.idle;
  bool get isFinished => status == TypingStatus.finished;

  /// Đổi cài đặt (ngôn ngữ / chế độ / thời lượng) chỉ khi bài chưa chạy.
  bool get canChangeSettings => !isRunning;

  /// mm:ss
  String get remainingLabel {
    final m = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// WPM tốt nhất hôm nay — để biết mình có phá kỷ lục trong ngày không.
  double get todayBestWpm =>
      todayResults.fold(0.0, (m, r) => r.wpm > m ? r.wpm : m);

  TypingState copyWith({
    TypingStatus? status,
    TypingLanguage? language,
    TypingMode? mode,
    int? durationSeconds,
    int? remainingSeconds,
    String? prompt,
    String? typed,
    TypingMetrics? metrics,
    bool? loadingContent,
    List<TypingResult>? todayResults,
    String? errorMessage,
  }) {
    return TypingState(
      status: status ?? this.status,
      language: language ?? this.language,
      mode: mode ?? this.mode,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      prompt: prompt ?? this.prompt,
      typed: typed ?? this.typed,
      metrics: metrics ?? this.metrics,
      loadingContent: loadingContent ?? this.loadingContent,
      todayResults: todayResults ?? this.todayResults,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        language,
        mode,
        durationSeconds,
        remainingSeconds,
        prompt,
        typed,
        metrics,
        loadingContent,
        todayResults,
        errorMessage,
      ];
}
