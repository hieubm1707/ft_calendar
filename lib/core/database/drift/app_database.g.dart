// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EventTableTable extends EventTable
    with TableInfo<$EventTableTable, EventTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAllDayMeta = const VerificationMeta(
    'isAllDay',
  );
  @override
  late final GeneratedColumn<bool> isAllDay = GeneratedColumn<bool>(
    'is_all_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_all_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF2196F3),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    startTime,
    endTime,
    isAllDay,
    color,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('is_all_day')) {
      context.handle(
        _isAllDayMeta,
        isAllDay.isAcceptableOrUnknown(data['is_all_day']!, _isAllDayMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      isAllDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_all_day'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
    );
  }

  @override
  $EventTableTable createAlias(String alias) {
    return $EventTableTable(attachedDatabase, alias);
  }
}

class EventTableData extends DataClass implements Insertable<EventTableData> {
  final int id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final int color;
  const EventTableData({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.isAllDay,
    required this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['is_all_day'] = Variable<bool>(isAllDay);
    map['color'] = Variable<int>(color);
    return map;
  }

  EventTableCompanion toCompanion(bool nullToAbsent) {
    return EventTableCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      startTime: Value(startTime),
      endTime: Value(endTime),
      isAllDay: Value(isAllDay),
      color: Value(color),
    );
  }

  factory EventTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      isAllDay: serializer.fromJson<bool>(json['isAllDay']),
      color: serializer.fromJson<int>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'isAllDay': serializer.toJson<bool>(isAllDay),
      'color': serializer.toJson<int>(color),
    };
  }

  EventTableData copyWith({
    int? id,
    String? title,
    Value<String?> description = const Value.absent(),
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    int? color,
  }) => EventTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    isAllDay: isAllDay ?? this.isAllDay,
    color: color ?? this.color,
  );
  EventTableData copyWithCompanion(EventTableCompanion data) {
    return EventTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      isAllDay: data.isAllDay.present ? data.isAllDay.value : this.isAllDay,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, description, startTime, endTime, isAllDay, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.isAllDay == this.isAllDay &&
          other.color == this.color);
}

class EventTableCompanion extends UpdateCompanion<EventTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<bool> isAllDay;
  final Value<int> color;
  const EventTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.isAllDay = const Value.absent(),
    this.color = const Value.absent(),
  });
  EventTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required DateTime startTime,
    required DateTime endTime,
    this.isAllDay = const Value.absent(),
    this.color = const Value.absent(),
  }) : title = Value(title),
       startTime = Value(startTime),
       endTime = Value(endTime);
  static Insertable<EventTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<bool>? isAllDay,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (isAllDay != null) 'is_all_day': isAllDay,
      if (color != null) 'color': color,
    });
  }

  EventTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<bool>? isAllDay,
    Value<int>? color,
  }) {
    return EventTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (isAllDay.present) {
      map['is_all_day'] = Variable<bool>(isAllDay.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $TaskScheduleTableTable extends TaskScheduleTable
    with TableInfo<$TaskScheduleTableTable, TaskScheduleTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskScheduleTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datesCsvMeta = const VerificationMeta(
    'datesCsv',
  );
  @override
  late final GeneratedColumn<String> datesCsv = GeneratedColumn<String>(
    'dates_csv',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weekdaysMaskMeta = const VerificationMeta(
    'weekdaysMask',
  );
  @override
  late final GeneratedColumn<int> weekdaysMask = GeneratedColumn<int>(
    'weekdays_mask',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF00B3A6),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minutesOfDayMeta = const VerificationMeta(
    'minutesOfDay',
  );
  @override
  late final GeneratedColumn<int> minutesOfDay = GeneratedColumn<int>(
    'minutes_of_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    type,
    datesCsv,
    weekdaysMask,
    startDate,
    active,
    color,
    createdAt,
    note,
    minutesOfDay,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_schedule_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskScheduleTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('dates_csv')) {
      context.handle(
        _datesCsvMeta,
        datesCsv.isAcceptableOrUnknown(data['dates_csv']!, _datesCsvMeta),
      );
    }
    if (data.containsKey('weekdays_mask')) {
      context.handle(
        _weekdaysMaskMeta,
        weekdaysMask.isAcceptableOrUnknown(
          data['weekdays_mask']!,
          _weekdaysMaskMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('minutes_of_day')) {
      context.handle(
        _minutesOfDayMeta,
        minutesOfDay.isAcceptableOrUnknown(
          data['minutes_of_day']!,
          _minutesOfDayMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskScheduleTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskScheduleTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      datesCsv: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dates_csv'],
      ),
      weekdaysMask: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekdays_mask'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      minutesOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes_of_day'],
      ),
    );
  }

  @override
  $TaskScheduleTableTable createAlias(String alias) {
    return $TaskScheduleTableTable(attachedDatabase, alias);
  }
}

class TaskScheduleTableData extends DataClass
    implements Insertable<TaskScheduleTableData> {
  final int id;
  final String title;
  final String type;
  final String? datesCsv;
  final int weekdaysMask;
  final DateTime startDate;
  final bool active;
  final int color;
  final DateTime createdAt;

  /// Mô tả (tuỳ chọn).
  final String? note;

  /// Giờ trong ngày (phút từ 0h) — tuỳ chọn, null = không đặt giờ.
  final int? minutesOfDay;
  const TaskScheduleTableData({
    required this.id,
    required this.title,
    required this.type,
    this.datesCsv,
    required this.weekdaysMask,
    required this.startDate,
    required this.active,
    required this.color,
    required this.createdAt,
    this.note,
    this.minutesOfDay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || datesCsv != null) {
      map['dates_csv'] = Variable<String>(datesCsv);
    }
    map['weekdays_mask'] = Variable<int>(weekdaysMask);
    map['start_date'] = Variable<DateTime>(startDate);
    map['active'] = Variable<bool>(active);
    map['color'] = Variable<int>(color);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || minutesOfDay != null) {
      map['minutes_of_day'] = Variable<int>(minutesOfDay);
    }
    return map;
  }

  TaskScheduleTableCompanion toCompanion(bool nullToAbsent) {
    return TaskScheduleTableCompanion(
      id: Value(id),
      title: Value(title),
      type: Value(type),
      datesCsv: datesCsv == null && nullToAbsent
          ? const Value.absent()
          : Value(datesCsv),
      weekdaysMask: Value(weekdaysMask),
      startDate: Value(startDate),
      active: Value(active),
      color: Value(color),
      createdAt: Value(createdAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      minutesOfDay: minutesOfDay == null && nullToAbsent
          ? const Value.absent()
          : Value(minutesOfDay),
    );
  }

  factory TaskScheduleTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskScheduleTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String>(json['type']),
      datesCsv: serializer.fromJson<String?>(json['datesCsv']),
      weekdaysMask: serializer.fromJson<int>(json['weekdaysMask']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      active: serializer.fromJson<bool>(json['active']),
      color: serializer.fromJson<int>(json['color']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      note: serializer.fromJson<String?>(json['note']),
      minutesOfDay: serializer.fromJson<int?>(json['minutesOfDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(type),
      'datesCsv': serializer.toJson<String?>(datesCsv),
      'weekdaysMask': serializer.toJson<int>(weekdaysMask),
      'startDate': serializer.toJson<DateTime>(startDate),
      'active': serializer.toJson<bool>(active),
      'color': serializer.toJson<int>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'note': serializer.toJson<String?>(note),
      'minutesOfDay': serializer.toJson<int?>(minutesOfDay),
    };
  }

  TaskScheduleTableData copyWith({
    int? id,
    String? title,
    String? type,
    Value<String?> datesCsv = const Value.absent(),
    int? weekdaysMask,
    DateTime? startDate,
    bool? active,
    int? color,
    DateTime? createdAt,
    Value<String?> note = const Value.absent(),
    Value<int?> minutesOfDay = const Value.absent(),
  }) => TaskScheduleTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    type: type ?? this.type,
    datesCsv: datesCsv.present ? datesCsv.value : this.datesCsv,
    weekdaysMask: weekdaysMask ?? this.weekdaysMask,
    startDate: startDate ?? this.startDate,
    active: active ?? this.active,
    color: color ?? this.color,
    createdAt: createdAt ?? this.createdAt,
    note: note.present ? note.value : this.note,
    minutesOfDay: minutesOfDay.present ? minutesOfDay.value : this.minutesOfDay,
  );
  TaskScheduleTableData copyWithCompanion(TaskScheduleTableCompanion data) {
    return TaskScheduleTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      datesCsv: data.datesCsv.present ? data.datesCsv.value : this.datesCsv,
      weekdaysMask: data.weekdaysMask.present
          ? data.weekdaysMask.value
          : this.weekdaysMask,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      active: data.active.present ? data.active.value : this.active,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      note: data.note.present ? data.note.value : this.note,
      minutesOfDay: data.minutesOfDay.present
          ? data.minutesOfDay.value
          : this.minutesOfDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskScheduleTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('datesCsv: $datesCsv, ')
          ..write('weekdaysMask: $weekdaysMask, ')
          ..write('startDate: $startDate, ')
          ..write('active: $active, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('note: $note, ')
          ..write('minutesOfDay: $minutesOfDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    type,
    datesCsv,
    weekdaysMask,
    startDate,
    active,
    color,
    createdAt,
    note,
    minutesOfDay,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskScheduleTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.type == this.type &&
          other.datesCsv == this.datesCsv &&
          other.weekdaysMask == this.weekdaysMask &&
          other.startDate == this.startDate &&
          other.active == this.active &&
          other.color == this.color &&
          other.createdAt == this.createdAt &&
          other.note == this.note &&
          other.minutesOfDay == this.minutesOfDay);
}

class TaskScheduleTableCompanion
    extends UpdateCompanion<TaskScheduleTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> type;
  final Value<String?> datesCsv;
  final Value<int> weekdaysMask;
  final Value<DateTime> startDate;
  final Value<bool> active;
  final Value<int> color;
  final Value<DateTime> createdAt;
  final Value<String?> note;
  final Value<int?> minutesOfDay;
  const TaskScheduleTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.datesCsv = const Value.absent(),
    this.weekdaysMask = const Value.absent(),
    this.startDate = const Value.absent(),
    this.active = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.note = const Value.absent(),
    this.minutesOfDay = const Value.absent(),
  });
  TaskScheduleTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String type,
    this.datesCsv = const Value.absent(),
    this.weekdaysMask = const Value.absent(),
    required DateTime startDate,
    this.active = const Value.absent(),
    this.color = const Value.absent(),
    required DateTime createdAt,
    this.note = const Value.absent(),
    this.minutesOfDay = const Value.absent(),
  }) : title = Value(title),
       type = Value(type),
       startDate = Value(startDate),
       createdAt = Value(createdAt);
  static Insertable<TaskScheduleTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? type,
    Expression<String>? datesCsv,
    Expression<int>? weekdaysMask,
    Expression<DateTime>? startDate,
    Expression<bool>? active,
    Expression<int>? color,
    Expression<DateTime>? createdAt,
    Expression<String>? note,
    Expression<int>? minutesOfDay,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (datesCsv != null) 'dates_csv': datesCsv,
      if (weekdaysMask != null) 'weekdays_mask': weekdaysMask,
      if (startDate != null) 'start_date': startDate,
      if (active != null) 'active': active,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
      if (note != null) 'note': note,
      if (minutesOfDay != null) 'minutes_of_day': minutesOfDay,
    });
  }

  TaskScheduleTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? type,
    Value<String?>? datesCsv,
    Value<int>? weekdaysMask,
    Value<DateTime>? startDate,
    Value<bool>? active,
    Value<int>? color,
    Value<DateTime>? createdAt,
    Value<String?>? note,
    Value<int?>? minutesOfDay,
  }) {
    return TaskScheduleTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      datesCsv: datesCsv ?? this.datesCsv,
      weekdaysMask: weekdaysMask ?? this.weekdaysMask,
      startDate: startDate ?? this.startDate,
      active: active ?? this.active,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
      minutesOfDay: minutesOfDay ?? this.minutesOfDay,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (datesCsv.present) {
      map['dates_csv'] = Variable<String>(datesCsv.value);
    }
    if (weekdaysMask.present) {
      map['weekdays_mask'] = Variable<int>(weekdaysMask.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (minutesOfDay.present) {
      map['minutes_of_day'] = Variable<int>(minutesOfDay.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskScheduleTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('datesCsv: $datesCsv, ')
          ..write('weekdaysMask: $weekdaysMask, ')
          ..write('startDate: $startDate, ')
          ..write('active: $active, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('note: $note, ')
          ..write('minutesOfDay: $minutesOfDay')
          ..write(')'))
        .toString();
  }
}

class $TaskCompletionTableTable extends TaskCompletionTable
    with TableInfo<$TaskCompletionTableTable, TaskCompletionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCompletionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta(
    'scheduleId',
  );
  @override
  late final GeneratedColumn<int> scheduleId = GeneratedColumn<int>(
    'schedule_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, scheduleId, date, done];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_completion_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskCompletionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskCompletionTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCompletionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schedule_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
    );
  }

  @override
  $TaskCompletionTableTable createAlias(String alias) {
    return $TaskCompletionTableTable(attachedDatabase, alias);
  }
}

class TaskCompletionTableData extends DataClass
    implements Insertable<TaskCompletionTableData> {
  final int id;
  final int scheduleId;
  final DateTime date;
  final bool done;
  const TaskCompletionTableData({
    required this.id,
    required this.scheduleId,
    required this.date,
    required this.done,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['schedule_id'] = Variable<int>(scheduleId);
    map['date'] = Variable<DateTime>(date);
    map['done'] = Variable<bool>(done);
    return map;
  }

  TaskCompletionTableCompanion toCompanion(bool nullToAbsent) {
    return TaskCompletionTableCompanion(
      id: Value(id),
      scheduleId: Value(scheduleId),
      date: Value(date),
      done: Value(done),
    );
  }

  factory TaskCompletionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCompletionTableData(
      id: serializer.fromJson<int>(json['id']),
      scheduleId: serializer.fromJson<int>(json['scheduleId']),
      date: serializer.fromJson<DateTime>(json['date']),
      done: serializer.fromJson<bool>(json['done']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scheduleId': serializer.toJson<int>(scheduleId),
      'date': serializer.toJson<DateTime>(date),
      'done': serializer.toJson<bool>(done),
    };
  }

  TaskCompletionTableData copyWith({
    int? id,
    int? scheduleId,
    DateTime? date,
    bool? done,
  }) => TaskCompletionTableData(
    id: id ?? this.id,
    scheduleId: scheduleId ?? this.scheduleId,
    date: date ?? this.date,
    done: done ?? this.done,
  );
  TaskCompletionTableData copyWithCompanion(TaskCompletionTableCompanion data) {
    return TaskCompletionTableData(
      id: data.id.present ? data.id.value : this.id,
      scheduleId: data.scheduleId.present
          ? data.scheduleId.value
          : this.scheduleId,
      date: data.date.present ? data.date.value : this.date,
      done: data.done.present ? data.done.value : this.done,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskCompletionTableData(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('date: $date, ')
          ..write('done: $done')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, scheduleId, date, done);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCompletionTableData &&
          other.id == this.id &&
          other.scheduleId == this.scheduleId &&
          other.date == this.date &&
          other.done == this.done);
}

class TaskCompletionTableCompanion
    extends UpdateCompanion<TaskCompletionTableData> {
  final Value<int> id;
  final Value<int> scheduleId;
  final Value<DateTime> date;
  final Value<bool> done;
  const TaskCompletionTableCompanion({
    this.id = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.date = const Value.absent(),
    this.done = const Value.absent(),
  });
  TaskCompletionTableCompanion.insert({
    this.id = const Value.absent(),
    required int scheduleId,
    required DateTime date,
    this.done = const Value.absent(),
  }) : scheduleId = Value(scheduleId),
       date = Value(date);
  static Insertable<TaskCompletionTableData> custom({
    Expression<int>? id,
    Expression<int>? scheduleId,
    Expression<DateTime>? date,
    Expression<bool>? done,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (date != null) 'date': date,
      if (done != null) 'done': done,
    });
  }

  TaskCompletionTableCompanion copyWith({
    Value<int>? id,
    Value<int>? scheduleId,
    Value<DateTime>? date,
    Value<bool>? done,
  }) {
    return TaskCompletionTableCompanion(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      date: date ?? this.date,
      done: done ?? this.done,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<int>(scheduleId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCompletionTableCompanion(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('date: $date, ')
          ..write('done: $done')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EventTableTable eventTable = $EventTableTable(this);
  late final $TaskScheduleTableTable taskScheduleTable =
      $TaskScheduleTableTable(this);
  late final $TaskCompletionTableTable taskCompletionTable =
      $TaskCompletionTableTable(this);
  late final EventDao eventDao = EventDao(this as AppDatabase);
  late final TaskDao taskDao = TaskDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    eventTable,
    taskScheduleTable,
    taskCompletionTable,
  ];
}

typedef $$EventTableTableCreateCompanionBuilder =
    EventTableCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> description,
      required DateTime startTime,
      required DateTime endTime,
      Value<bool> isAllDay,
      Value<int> color,
    });
typedef $$EventTableTableUpdateCompanionBuilder =
    EventTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> description,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<bool> isAllDay,
      Value<int> color,
    });

class $$EventTableTableFilterComposer
    extends Composer<_$AppDatabase, $EventTableTable> {
  $$EventTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAllDay => $composableBuilder(
    column: $table.isAllDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EventTableTable> {
  $$EventTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAllDay => $composableBuilder(
    column: $table.isAllDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventTableTable> {
  $$EventTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<bool> get isAllDay =>
      $composableBuilder(column: $table.isAllDay, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$EventTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventTableTable,
          EventTableData,
          $$EventTableTableFilterComposer,
          $$EventTableTableOrderingComposer,
          $$EventTableTableAnnotationComposer,
          $$EventTableTableCreateCompanionBuilder,
          $$EventTableTableUpdateCompanionBuilder,
          (
            EventTableData,
            BaseReferences<_$AppDatabase, $EventTableTable, EventTableData>,
          ),
          EventTableData,
          PrefetchHooks Function()
        > {
  $$EventTableTableTableManager(_$AppDatabase db, $EventTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<bool> isAllDay = const Value.absent(),
                Value<int> color = const Value.absent(),
              }) => EventTableCompanion(
                id: id,
                title: title,
                description: description,
                startTime: startTime,
                endTime: endTime,
                isAllDay: isAllDay,
                color: color,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                required DateTime startTime,
                required DateTime endTime,
                Value<bool> isAllDay = const Value.absent(),
                Value<int> color = const Value.absent(),
              }) => EventTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                startTime: startTime,
                endTime: endTime,
                isAllDay: isAllDay,
                color: color,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventTableTable,
      EventTableData,
      $$EventTableTableFilterComposer,
      $$EventTableTableOrderingComposer,
      $$EventTableTableAnnotationComposer,
      $$EventTableTableCreateCompanionBuilder,
      $$EventTableTableUpdateCompanionBuilder,
      (
        EventTableData,
        BaseReferences<_$AppDatabase, $EventTableTable, EventTableData>,
      ),
      EventTableData,
      PrefetchHooks Function()
    >;
typedef $$TaskScheduleTableTableCreateCompanionBuilder =
    TaskScheduleTableCompanion Function({
      Value<int> id,
      required String title,
      required String type,
      Value<String?> datesCsv,
      Value<int> weekdaysMask,
      required DateTime startDate,
      Value<bool> active,
      Value<int> color,
      required DateTime createdAt,
      Value<String?> note,
      Value<int?> minutesOfDay,
    });
typedef $$TaskScheduleTableTableUpdateCompanionBuilder =
    TaskScheduleTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> type,
      Value<String?> datesCsv,
      Value<int> weekdaysMask,
      Value<DateTime> startDate,
      Value<bool> active,
      Value<int> color,
      Value<DateTime> createdAt,
      Value<String?> note,
      Value<int?> minutesOfDay,
    });

class $$TaskScheduleTableTableFilterComposer
    extends Composer<_$AppDatabase, $TaskScheduleTableTable> {
  $$TaskScheduleTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datesCsv => $composableBuilder(
    column: $table.datesCsv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekdaysMask => $composableBuilder(
    column: $table.weekdaysMask,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutesOfDay => $composableBuilder(
    column: $table.minutesOfDay,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskScheduleTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskScheduleTableTable> {
  $$TaskScheduleTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datesCsv => $composableBuilder(
    column: $table.datesCsv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekdaysMask => $composableBuilder(
    column: $table.weekdaysMask,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutesOfDay => $composableBuilder(
    column: $table.minutesOfDay,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskScheduleTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskScheduleTableTable> {
  $$TaskScheduleTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get datesCsv =>
      $composableBuilder(column: $table.datesCsv, builder: (column) => column);

  GeneratedColumn<int> get weekdaysMask => $composableBuilder(
    column: $table.weekdaysMask,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get minutesOfDay => $composableBuilder(
    column: $table.minutesOfDay,
    builder: (column) => column,
  );
}

class $$TaskScheduleTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskScheduleTableTable,
          TaskScheduleTableData,
          $$TaskScheduleTableTableFilterComposer,
          $$TaskScheduleTableTableOrderingComposer,
          $$TaskScheduleTableTableAnnotationComposer,
          $$TaskScheduleTableTableCreateCompanionBuilder,
          $$TaskScheduleTableTableUpdateCompanionBuilder,
          (
            TaskScheduleTableData,
            BaseReferences<
              _$AppDatabase,
              $TaskScheduleTableTable,
              TaskScheduleTableData
            >,
          ),
          TaskScheduleTableData,
          PrefetchHooks Function()
        > {
  $$TaskScheduleTableTableTableManager(
    _$AppDatabase db,
    $TaskScheduleTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskScheduleTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskScheduleTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskScheduleTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> datesCsv = const Value.absent(),
                Value<int> weekdaysMask = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> minutesOfDay = const Value.absent(),
              }) => TaskScheduleTableCompanion(
                id: id,
                title: title,
                type: type,
                datesCsv: datesCsv,
                weekdaysMask: weekdaysMask,
                startDate: startDate,
                active: active,
                color: color,
                createdAt: createdAt,
                note: note,
                minutesOfDay: minutesOfDay,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String type,
                Value<String?> datesCsv = const Value.absent(),
                Value<int> weekdaysMask = const Value.absent(),
                required DateTime startDate,
                Value<bool> active = const Value.absent(),
                Value<int> color = const Value.absent(),
                required DateTime createdAt,
                Value<String?> note = const Value.absent(),
                Value<int?> minutesOfDay = const Value.absent(),
              }) => TaskScheduleTableCompanion.insert(
                id: id,
                title: title,
                type: type,
                datesCsv: datesCsv,
                weekdaysMask: weekdaysMask,
                startDate: startDate,
                active: active,
                color: color,
                createdAt: createdAt,
                note: note,
                minutesOfDay: minutesOfDay,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskScheduleTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskScheduleTableTable,
      TaskScheduleTableData,
      $$TaskScheduleTableTableFilterComposer,
      $$TaskScheduleTableTableOrderingComposer,
      $$TaskScheduleTableTableAnnotationComposer,
      $$TaskScheduleTableTableCreateCompanionBuilder,
      $$TaskScheduleTableTableUpdateCompanionBuilder,
      (
        TaskScheduleTableData,
        BaseReferences<
          _$AppDatabase,
          $TaskScheduleTableTable,
          TaskScheduleTableData
        >,
      ),
      TaskScheduleTableData,
      PrefetchHooks Function()
    >;
typedef $$TaskCompletionTableTableCreateCompanionBuilder =
    TaskCompletionTableCompanion Function({
      Value<int> id,
      required int scheduleId,
      required DateTime date,
      Value<bool> done,
    });
typedef $$TaskCompletionTableTableUpdateCompanionBuilder =
    TaskCompletionTableCompanion Function({
      Value<int> id,
      Value<int> scheduleId,
      Value<DateTime> date,
      Value<bool> done,
    });

class $$TaskCompletionTableTableFilterComposer
    extends Composer<_$AppDatabase, $TaskCompletionTableTable> {
  $$TaskCompletionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskCompletionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskCompletionTableTable> {
  $$TaskCompletionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskCompletionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskCompletionTableTable> {
  $$TaskCompletionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);
}

class $$TaskCompletionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskCompletionTableTable,
          TaskCompletionTableData,
          $$TaskCompletionTableTableFilterComposer,
          $$TaskCompletionTableTableOrderingComposer,
          $$TaskCompletionTableTableAnnotationComposer,
          $$TaskCompletionTableTableCreateCompanionBuilder,
          $$TaskCompletionTableTableUpdateCompanionBuilder,
          (
            TaskCompletionTableData,
            BaseReferences<
              _$AppDatabase,
              $TaskCompletionTableTable,
              TaskCompletionTableData
            >,
          ),
          TaskCompletionTableData,
          PrefetchHooks Function()
        > {
  $$TaskCompletionTableTableTableManager(
    _$AppDatabase db,
    $TaskCompletionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskCompletionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskCompletionTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TaskCompletionTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> scheduleId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> done = const Value.absent(),
              }) => TaskCompletionTableCompanion(
                id: id,
                scheduleId: scheduleId,
                date: date,
                done: done,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int scheduleId,
                required DateTime date,
                Value<bool> done = const Value.absent(),
              }) => TaskCompletionTableCompanion.insert(
                id: id,
                scheduleId: scheduleId,
                date: date,
                done: done,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskCompletionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskCompletionTableTable,
      TaskCompletionTableData,
      $$TaskCompletionTableTableFilterComposer,
      $$TaskCompletionTableTableOrderingComposer,
      $$TaskCompletionTableTableAnnotationComposer,
      $$TaskCompletionTableTableCreateCompanionBuilder,
      $$TaskCompletionTableTableUpdateCompanionBuilder,
      (
        TaskCompletionTableData,
        BaseReferences<
          _$AppDatabase,
          $TaskCompletionTableTable,
          TaskCompletionTableData
        >,
      ),
      TaskCompletionTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EventTableTableTableManager get eventTable =>
      $$EventTableTableTableManager(_db, _db.eventTable);
  $$TaskScheduleTableTableTableManager get taskScheduleTable =>
      $$TaskScheduleTableTableTableManager(_db, _db.taskScheduleTable);
  $$TaskCompletionTableTableTableManager get taskCompletionTable =>
      $$TaskCompletionTableTableTableManager(_db, _db.taskCompletionTable);
}
