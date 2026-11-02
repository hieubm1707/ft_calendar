import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tracking_table.dart';

part 'tracking_dao.g.dart';

/// Truy vấn Drift cho mục tiêu tracking + lượt hoàn thành. Chỉ SQL, không nghiệp vụ.
@DriftAccessor(tables: [TrackingGoalTable, TrackingCheckinTable])
class TrackingDao extends DatabaseAccessor<AppDatabase>
    with _$TrackingDaoMixin {
  TrackingDao(super.db);

  Future<int> insertGoal(TrackingGoalTableCompanion goal) {
    return into(trackingGoalTable).insert(goal);
  }

  Future<void> updateGoal(int id, TrackingGoalTableCompanion goal) {
    return (update(
      trackingGoalTable,
    )..where((t) => t.id.equals(id))).write(goal);
  }

  Future<void> deleteGoal(int id) async {
    await (delete(
      trackingCheckinTable,
    )..where((t) => t.goalId.equals(id))).go();
    await (delete(trackingGoalTable)..where((t) => t.id.equals(id))).go();
  }

  Future<List<TrackingGoalTableData>> getGoals() {
    return (select(
      trackingGoalTable,
    )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).get();
  }

  Future<List<TrackingCheckinTableData>> getCheckins() {
    return select(trackingCheckinTable).get();
  }

  /// Đặt/bỏ hoàn thành cho (goalId, date): xoá dòng cũ rồi thêm nếu [done].
  Future<void> setCheckin(int goalId, DateTime date, bool done) async {
    await (delete(
      trackingCheckinTable,
    )..where((t) => t.goalId.equals(goalId) & t.date.equals(date))).go();
    if (!done) return;
    await into(
      trackingCheckinTable,
    ).insert(TrackingCheckinTableCompanion.insert(goalId: goalId, date: date));
  }
}
