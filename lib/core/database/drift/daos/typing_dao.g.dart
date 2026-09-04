// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_dao.dart';

// ignore_for_file: type=lint
mixin _$TypingDaoMixin on DatabaseAccessor<AppDatabase> {
  $TypingResultTableTable get typingResultTable =>
      attachedDatabase.typingResultTable;
  TypingDaoManager get managers => TypingDaoManager(this);
}

class TypingDaoManager {
  final _$TypingDaoMixin _db;
  TypingDaoManager(this._db);
  $$TypingResultTableTableTableManager get typingResultTable =>
      $$TypingResultTableTableTableManager(
        _db.attachedDatabase,
        _db.typingResultTable,
      );
}
