import 'package:drift/drift.dart';

import '../../../../core/database/drift/index.dart';
import '../../domain/index.dart';

extension FocusTagRowMapper on FocusTagTableData {
  FocusTag toEntity() => FocusTag(
        id: id,
        title: title,
        minutes: minutes,
        color: color,
        emoji: emoji,
        sortOrder: sortOrder,
      );
}

extension FocusTagEntityMapper on FocusTag {
  FocusTagTableCompanion toInsertCompanion() => FocusTagTableCompanion.insert(
        title: title,
        minutes: minutes,
        color: Value(color),
        emoji: Value(emoji),
        sortOrder: Value(sortOrder),
      );

  /// Companion cho `update` — không đụng tới `id`.
  FocusTagTableCompanion toUpdateCompanion() => FocusTagTableCompanion(
        title: Value(title),
        minutes: Value(minutes),
        color: Value(color),
        emoji: Value(emoji),
        sortOrder: Value(sortOrder),
      );
}
