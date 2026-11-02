import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/index.dart';

part 'typing_history_state.dart';

/// Lịch sử kết quả gõ phím: nền tảng là tổng hợp THEO NGÀY, các bộ lọc
/// tuần/tháng/năm/tuỳ chọn chỉ đổi khoảng ngày được gom.
@injectable
class TypingHistoryCubit extends Cubit<TypingHistoryState> {
  final GetTypingResults _getResults;
  final DeleteTypingResult _deleteResult;

  TypingHistoryCubit(this._getResults, this._deleteResult)
      : super(TypingHistoryState());

  /// Nạp lịch sử. [range] null = giữ khoảng hiện tại.
  /// Với [TypingRange.custom] phải truyền [from]/[to].
  Future<void> load({TypingRange? range, DateTime? from, DateTime? to}) async {
    final selected = range ?? state.range;
    final bounds = _boundsFor(selected, from: from, to: to);

    emit(state.copyWith(
      status: TypingHistoryStatus.loading,
      range: selected,
      from: bounds.from,
      to: bounds.to,
    ));

    final result = await _getResults(GetTypingResultsParams(
      from: bounds.from,
      to: bounds.to.add(const Duration(days: 1)), // [from, to] theo ngày
    ));
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
          status: TypingHistoryStatus.failure, errorMessage: failure.message)),
      (results) => emit(state.copyWith(
        status: TypingHistoryStatus.success,
        results: results,
        report: summarizeTyping(
          results: results,
          from: bounds.from,
          to: bounds.to,
        ),
      )),
    );
  }

  Future<void> changeRange(TypingRange range) => load(range: range);

  /// Chọn khoảng bất kỳ: từ ngày → đến ngày.
  Future<void> setCustomRange(DateTime from, DateTime to) =>
      load(range: TypingRange.custom, from: from, to: to);

  Future<void> remove(int id) async {
    final result = await _deleteResult(id);
    if (isClosed) return;
    await result.fold(
      (failure) async => emit(state.copyWith(
          status: TypingHistoryStatus.failure, errorMessage: failure.message)),
      (_) async => load(),
    );
  }

  /// Khoảng ngày của từng bộ lọc — luôn kết thúc ở hôm nay (trừ khoảng tuỳ chọn).
  ({DateTime from, DateTime to}) _boundsFor(
    TypingRange range, {
    DateTime? from,
    DateTime? to,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (range) {
      case TypingRange.week:
        // Tuần này: từ thứ Hai.
        return (
          from: today.subtract(Duration(days: today.weekday - 1)),
          to: today
        );
      case TypingRange.month:
        return (from: DateTime(today.year, today.month), to: today);
      case TypingRange.year:
        return (from: DateTime(today.year), to: today);
      case TypingRange.custom:
        final start = _dayOnly(from ?? state.from);
        final end = _dayOnly(to ?? state.to);
        return end.isBefore(start)
            ? (from: end, to: start)
            : (from: start, to: end);
    }
  }

  DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
