import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/index.dart';
import '../../domain/index.dart';
import '../reminders/tracking_reminder_sync.dart';

enum TrackingReminderStatus { initial, loading, success, failure }

class TrackingReminderState extends Equatable {
  final TrackingReminderStatus status;

  /// Bộ nhắc, sắp theo giờ tăng dần.
  final List<TrackingReminderRule> rules;
  final String? errorMessage;

  const TrackingReminderState({
    this.status = TrackingReminderStatus.initial,
    this.rules = const [],
    this.errorMessage,
  });

  bool get canAdd => rules.length < TrackingReminderRule.maxRules;

  TrackingReminderState copyWith({
    TrackingReminderStatus? status,
    List<TrackingReminderRule>? rules,
    String? errorMessage,
  }) {
    return TrackingReminderState(
      status: status ?? this.status,
      rules: rules ?? this.rules,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, rules, errorMessage];
}

/// Trang cài đặt bộ nhắc Tracking: thêm/sửa/xoá/bật-tắt luật (giờ + điều kiện %).
/// Lưu xong thì đặt lại thông báo qua [TrackingReminderSync].
@injectable
class TrackingReminderCubit extends Cubit<TrackingReminderState> {
  final GetTrackingReminderRules _getRules;
  final SaveTrackingReminderRules _saveRules;
  final TrackingReminderSync _sync;

  TrackingReminderCubit(this._getRules, this._saveRules, this._sync)
    : super(const TrackingReminderState());

  Future<void> load() async {
    emit(state.copyWith(status: TrackingReminderStatus.loading));
    final result = await _getRules(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TrackingReminderStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (rules) => emit(
        state.copyWith(status: TrackingReminderStatus.success, rules: rules),
      ),
    );
  }

  Future<void> add(TrackingReminderRule rule) async {
    if (!state.canAdd) return;
    await _save([...state.rules, rule]);
  }

  Future<void> replace(TrackingReminderRule old, TrackingReminderRule rule) =>
      _save([for (final r in state.rules) identical(r, old) ? rule : r]);

  Future<void> remove(TrackingReminderRule rule) => _save([
    for (final r in state.rules)
      if (!identical(r, rule)) r,
  ]);

  Future<void> toggle(TrackingReminderRule rule) =>
      replace(rule, rule.copyWith(enabled: !rule.enabled));

  Future<void> resetDefaults() => _save(TrackingReminderRule.defaults);

  Future<void> _save(List<TrackingReminderRule> rules) async {
    final sorted = [...rules]..sort((a, b) => a.minutes.compareTo(b.minutes));
    final result = await _saveRules(sorted);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TrackingReminderStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        emit(
          state.copyWith(status: TrackingReminderStatus.success, rules: sorted),
        );
        _sync.sync();
      },
    );
  }
}
