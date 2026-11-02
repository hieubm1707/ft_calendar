// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_dao.dart';

// ignore_for_file: type=lint
mixin _$TrackingDaoMixin on DatabaseAccessor<AppDatabase> {
  $TrackingGoalTableTable get trackingGoalTable =>
      attachedDatabase.trackingGoalTable;
  $TrackingCheckinTableTable get trackingCheckinTable =>
      attachedDatabase.trackingCheckinTable;
  TrackingDaoManager get managers => TrackingDaoManager(this);
}

class TrackingDaoManager {
  final _$TrackingDaoMixin _db;
  TrackingDaoManager(this._db);
  $$TrackingGoalTableTableTableManager get trackingGoalTable =>
      $$TrackingGoalTableTableTableManager(
        _db.attachedDatabase,
        _db.trackingGoalTable,
      );
  $$TrackingCheckinTableTableTableManager get trackingCheckinTable =>
      $$TrackingCheckinTableTableTableManager(
        _db.attachedDatabase,
        _db.trackingCheckinTable,
      );
}
