import 'package:dartz/dartz.dart';
import 'package:drift/native.dart';
import 'package:example_app/core/database/drift/index.dart';
import 'package:example_app/core/error/index.dart';
import 'package:example_app/core/notifications/index.dart';
import 'package:example_app/core/theme/index.dart';
import 'package:example_app/features/tracking/data/index.dart';
import 'package:example_app/features/tracking/domain/index.dart';
import 'package:example_app/features/tracking/presentation/cubit/tracking_cubit.dart';
import 'package:example_app/features/tracking/presentation/pages/tracking_page.dart';
import 'package:example_app/features/tracking/presentation/reminders/tracking_reminder_sync.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

/// Giả lập plugin thông báo bị lỗi, vd. Android chặn báo thức chính xác.
class _ThrowingNotifications extends Fake implements NotificationService {
  @override
  Future<void> cancelMany(Iterable<int> ids) async => throw Exception('plugin');
}

class _NoSync extends Fake implements TrackingReminderSync {
  @override
  Future<void> sync() async {}
}

class _FailingRepository extends Fake implements TrackingRepository {
  @override
  Future<Either<Failure, TrackingOverview>> getOverview() async =>
      const Left(DatabaseFailure('hỏng DB'));
}

TrackingCubit _cubit(TrackingRepository repo) => TrackingCubit(
  GetTrackingOverview(repo),
  SaveTrackingGoal(repo),
  DeleteTrackingGoal(repo),
  SetTrackingCheckin(repo),
  _ThrowingNotifications(),
  _NoSync(),
);

void main() {
  group('deleteGoal', () {
    late AppDatabase db;
    late TrackingRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = TrackingRepositoryImpl(
        TrackingDriftDataSource(db.trackingDao, db.taskDao),
      );
    });
    tearDown(() => db.close());

    test('vẫn xoá mục tiêu khi huỷ nhắc bị lỗi', () async {
      final cubit = _cubit(repo);
      addTearDown(cubit.close);
      await cubit.saveGoal(
        TrackingGoal(
          name: 'Đọc sách',
          frequency: TrackingFrequency.daily,
          startDate: DateTime(2026, 11, 1),
        ),
      );
      expect(cubit.state.goals, hasLength(1));

      await cubit.deleteGoal(cubit.state.goals.single);

      expect(cubit.state.goals, isEmpty);
      expect(await db.trackingDao.getGoals(), isEmpty);
    });
  });

  group('snackbar lỗi ở TrackingPage', () {
    tearDown(() => GetIt.instance.reset());

    testWidgets('chọn ngày khác sau khi lỗi không hiện lại snackbar', (
      tester,
    ) async {
      final cubit = _cubit(_FailingRepository());
      GetIt.instance.registerFactory<TrackingCubit>(() => cubit);

      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light(), home: const TrackingPage()),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('hỏng DB'), findsOneWidget);

      ScaffoldMessenger.of(
        tester.element(find.byType(Scaffold).first),
      ).removeCurrentSnackBar();
      await tester.pump();

      final today = DateTime.now();
      cubit.selectDay(DateTime(today.year, today.month, today.day - 1));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsNothing);
      await tester.pump(const Duration(seconds: 5));
    });
  });
}
