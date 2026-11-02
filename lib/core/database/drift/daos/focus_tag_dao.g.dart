// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_tag_dao.dart';

// ignore_for_file: type=lint
mixin _$FocusTagDaoMixin on DatabaseAccessor<AppDatabase> {
  $FocusTagTableTable get focusTagTable => attachedDatabase.focusTagTable;
  FocusTagDaoManager get managers => FocusTagDaoManager(this);
}

class FocusTagDaoManager {
  final _$FocusTagDaoMixin _db;
  FocusTagDaoManager(this._db);
  $$FocusTagTableTableTableManager get focusTagTable =>
      $$FocusTagTableTableTableManager(_db.attachedDatabase, _db.focusTagTable);
}
