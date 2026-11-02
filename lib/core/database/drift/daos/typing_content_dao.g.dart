// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_content_dao.dart';

// ignore_for_file: type=lint
mixin _$TypingContentDaoMixin on DatabaseAccessor<AppDatabase> {
  $TypingContentPackTableTable get typingContentPackTable =>
      attachedDatabase.typingContentPackTable;
  TypingContentDaoManager get managers => TypingContentDaoManager(this);
}

class TypingContentDaoManager {
  final _$TypingContentDaoMixin _db;
  TypingContentDaoManager(this._db);
  $$TypingContentPackTableTableTableManager get typingContentPackTable =>
      $$TypingContentPackTableTableTableManager(
        _db.attachedDatabase,
        _db.typingContentPackTable,
      );
}
