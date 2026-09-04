import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/index.dart';

part 'typing_state.dart';

/// Bài test gõ phím theo thời gian: chọn ngôn ngữ + chế độ + thời lượng, gõ
/// tới khi hết giờ (hoặc gõ hết đề) rồi LƯU kết quả kèm ngày giờ.
///
/// Đồng hồ đếm ngược theo **mốc deadline đồng hồ thật** (giống pomodoro) nên
/// vẫn đúng khi app bị treo/ngủ giữa chừng.
@injectable
class TypingCubit extends Cubit<TypingState> {
  final GetTypingContent _getContent;
  final SaveTypingResult _saveResult;
  final GetTypingResults _getResults;

  TypingCubit(this._getContent, this._saveResult, this._getResults)
      : super(const TypingState());

  /// Các mốc thời lượng cho chọn nhanh (giây).
  static const durationPresets = [15, 30, 60, 120];

  /// Bài ngắn hơn mốc này không đủ để tính WPM có ý nghĩa → không lưu.
  static const _minSavedSeconds = 5;

  Timer? _ticker;

  /// Mốc kết thúc theo đồng hồ thật.
  DateTime? _deadline;

  /// Thời điểm gõ ký tự đầu tiên.
  DateTime? _startedAt;

  /// Kho nội dung của ngôn ngữ đang chọn.
  TypingContentBank _bank = const TypingContentBank(
    language: TypingLanguage.english,
  );

  /// Nạp kho nội dung + đề đầu tiên + kết quả hôm nay.
  Future<void> init() async {
    await Future.wait([_loadBank(state.language), _loadTodayResults()]);
  }

  // ── Cài đặt ───────────────────────────────────────────────────────────

  Future<void> setLanguage(TypingLanguage language) async {
    if (!state.canChangeSettings || language == state.language) return;
    emit(state.copyWith(language: language));
    await _loadBank(language);
  }

  void setMode(TypingMode mode) {
    if (!state.canChangeSettings || mode == state.mode) return;
    emit(state.copyWith(mode: mode));
    _newPrompt();
  }

  void setDuration(int seconds) {
    if (!state.canChangeSettings || seconds <= 0) return;
    emit(state.copyWith(durationSeconds: seconds));
    _newPrompt();
  }

  // ── Làm bài ───────────────────────────────────────────────────────────

  /// Người dùng vừa đổi nội dung ô nhập. Ký tự đầu tiên khởi động đồng hồ.
  void onTyped(String text) {
    if (state.isFinished) return;

    if (state.isIdle) {
      if (text.isEmpty) return; // xoá lùi về rỗng: chưa tính là bắt đầu
      _start();
    }

    final elapsed = _elapsed();
    emit(state.copyWith(
      typed: text,
      metrics: computeTypingMetrics(
        target: state.prompt,
        typed: text,
        elapsed: elapsed,
      ),
    ));

    // Gõ hết đề trước khi hết giờ → chốt bài luôn.
    if (state.prompt.isNotEmpty &&
        text.runes.length >= state.prompt.runes.length) {
      unawaited(_finish(elapsed: elapsed));
    }
  }

  /// Bỏ bài đang gõ, sinh đề mới. Bài đang chạy KHÔNG được lưu.
  void restart() {
    _stopTicker();
    _deadline = null;
    _startedAt = null;
    emit(state.copyWith(
      status: TypingStatus.idle,
      typed: '',
      metrics: const TypingMetrics(),
      remainingSeconds: state.durationSeconds,
    ));
    _newPrompt();
  }

  // ── Nội bộ ────────────────────────────────────────────────────────────

  void _start() {
    _startedAt = DateTime.now();
    _deadline = _startedAt!.add(Duration(seconds: state.durationSeconds));
    emit(state.copyWith(status: TypingStatus.running));
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _tick() {
    if (isClosed) return;
    final remaining = _remainingFromDeadline();
    if (remaining > 0) {
      // Cập nhật cả số liệu để WPM chạy đều kể cả lúc người dùng ngừng gõ.
      emit(state.copyWith(
        remainingSeconds: remaining,
        metrics: computeTypingMetrics(
          target: state.prompt,
          typed: state.typed,
          elapsed: _elapsed(),
        ),
      ));
      return;
    }
    unawaited(_finish(elapsed: Duration(seconds: state.durationSeconds)));
  }

  int _remainingFromDeadline() {
    final deadline = _deadline;
    if (deadline == null) return state.remainingSeconds;
    final ms = deadline.difference(DateTime.now()).inMilliseconds;
    return ms <= 0 ? 0 : (ms / 1000).ceil();
  }

  Duration _elapsed() {
    final started = _startedAt;
    if (started == null) return Duration.zero;
    final elapsed = DateTime.now().difference(started);
    final limit = Duration(seconds: state.durationSeconds);
    return elapsed > limit ? limit : elapsed;
  }

  /// Chốt bài: dừng đồng hồ, tính số liệu cuối rồi lưu kết quả.
  Future<void> _finish({required Duration elapsed}) async {
    if (state.isFinished) return;
    _stopTicker();
    _deadline = null;

    final metrics = computeTypingMetrics(
      target: state.prompt,
      typed: state.typed,
      elapsed: elapsed,
    );
    emit(state.copyWith(
      status: TypingStatus.finished,
      remainingSeconds: 0,
      metrics: metrics,
    ));
    _startedAt = null;

    final seconds = elapsed.inSeconds;
    if (seconds < _minSavedSeconds || metrics.typedChars == 0) return;

    final result = TypingResult(
      takenAt: DateTime.now(),
      language: state.language,
      mode: state.mode,
      durationSeconds: state.durationSeconds,
      elapsedSeconds: seconds,
      typedChars: metrics.typedChars,
      correctChars: metrics.correctChars,
      incorrectChars: metrics.incorrectChars,
      correctWords: metrics.correctWords,
      wpm: metrics.wpm,
      accuracy: metrics.accuracy,
    );

    final saved = await _saveResult(result);
    if (isClosed) return;
    await saved.fold(
      (failure) async => emit(state.copyWith(errorMessage: failure.message)),
      (_) async => _loadTodayResults(),
    );
  }

  Future<void> _loadBank(TypingLanguage language) async {
    emit(state.copyWith(loadingContent: true));
    final result = await _getContent(language);
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(
          loadingContent: false, errorMessage: failure.message)),
      (bank) {
        _bank = bank;
        emit(state.copyWith(loadingContent: false));
        _newPrompt();
      },
    );
  }

  Future<void> _loadTodayResults() async {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day);
    final to = from.add(const Duration(days: 1));

    final result = await _getResults(GetTypingResultsParams(from: from, to: to));
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (results) => emit(state.copyWith(todayResults: results)),
    );
  }

  /// Sinh đề mới theo cài đặt hiện tại và xoá chuỗi đã gõ.
  void _newPrompt() {
    emit(state.copyWith(
      prompt: buildPrompt(
        bank: _bank,
        mode: state.mode,
        durationSeconds: state.durationSeconds,
      ),
      typed: '',
      metrics: const TypingMetrics(),
      status: TypingStatus.idle,
      remainingSeconds: state.durationSeconds,
    ));
  }

  @override
  Future<void> close() {
    _stopTicker();
    return super.close();
  }
}
