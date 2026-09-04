part of 'typing_history_cubit.dart';

enum TypingHistoryStatus { initial, loading, success, failure }

/// Bộ lọc khoảng thời gian xem lịch sử. [custom] = tự chọn từ ngày → đến ngày.
enum TypingRange { week, month, year, custom }

class TypingHistoryState extends Equatable {
  final TypingHistoryStatus status;
  final TypingRange range;

  /// Khoảng đang xem (đã chuẩn hoá về ngày, bao gồm cả 2 đầu).
  final DateTime from;
  final DateTime to;

  final TypingReport report;

  /// Kết quả trong khoảng, mới nhất trước.
  final List<TypingResult> results;

  final String? errorMessage;

  TypingHistoryState({
    this.status = TypingHistoryStatus.initial,
    this.range = TypingRange.week,
    DateTime? from,
    DateTime? to,
    TypingReport? report,
    this.results = const [],
    this.errorMessage,
  })  : from = from ?? DateTime(2000),
        to = to ?? DateTime(2000),
        report = report ?? TypingReport.empty;

  TypingHistoryState copyWith({
    TypingHistoryStatus? status,
    TypingRange? range,
    DateTime? from,
    DateTime? to,
    TypingReport? report,
    List<TypingResult>? results,
    String? errorMessage,
  }) {
    return TypingHistoryState(
      status: status ?? this.status,
      range: range ?? this.range,
      from: from ?? this.from,
      to: to ?? this.to,
      report: report ?? this.report,
      results: results ?? this.results,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, range, from, to, report, results, errorMessage];
}
