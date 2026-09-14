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

class $PomodoroSessionTableTable extends PomodoroSessionTable
    with TableInfo<$PomodoroSessionTableTable, PomodoroSessionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PomodoroSessionTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focusSecondsMeta = const VerificationMeta(
    'focusSeconds',
  );
  @override
  late final GeneratedColumn<int> focusSeconds = GeneratedColumn<int>(
    'focus_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedSecondsMeta = const VerificationMeta(
    'plannedSeconds',
  );
  @override
  late final GeneratedColumn<int> plannedSeconds = GeneratedColumn<int>(
    'planned_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskScheduleIdMeta = const VerificationMeta(
    'taskScheduleId',
  );
  @override
  late final GeneratedColumn<int> taskScheduleId = GeneratedColumn<int>(
    'task_schedule_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _focusTagIdMeta = const VerificationMeta(
    'focusTagId',
  );
  @override
  late final GeneratedColumn<int> focusTagId = GeneratedColumn<int>(
    'focus_tag_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    endedAt,
    focusSeconds,
    plannedSeconds,
    completed,
    label,
    taskScheduleId,
    focusTagId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pomodoro_session_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PomodoroSessionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('focus_seconds')) {
      context.handle(
        _focusSecondsMeta,
        focusSeconds.isAcceptableOrUnknown(
          data['focus_seconds']!,
          _focusSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_focusSecondsMeta);
    }
    if (data.containsKey('planned_seconds')) {
      context.handle(
        _plannedSecondsMeta,
        plannedSeconds.isAcceptableOrUnknown(
          data['planned_seconds']!,
          _plannedSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedSecondsMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('task_schedule_id')) {
      context.handle(
        _taskScheduleIdMeta,
        taskScheduleId.isAcceptableOrUnknown(
          data['task_schedule_id']!,
          _taskScheduleIdMeta,
        ),
      );
    }
    if (data.containsKey('focus_tag_id')) {
      context.handle(
        _focusTagIdMeta,
        focusTagId.isAcceptableOrUnknown(
          data['focus_tag_id']!,
          _focusTagIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PomodoroSessionTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PomodoroSessionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
      focusSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_seconds'],
      )!,
      plannedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_seconds'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      taskScheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_schedule_id'],
      ),
      focusTagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_tag_id'],
      ),
    );
  }

  @override
  $PomodoroSessionTableTable createAlias(String alias) {
    return $PomodoroSessionTableTable(attachedDatabase, alias);
  }
}

class PomodoroSessionTableData extends DataClass
    implements Insertable<PomodoroSessionTableData> {
  final int id;
  final DateTime startedAt;
  final DateTime endedAt;

  /// Số giây thực sự đã tập trung (không tính lúc pause bị dừng sớm).
  final int focusSeconds;

  /// Độ dài phiên đã đặt (giây) — để biết phiên có chạy hết hay không.
  final int plannedSeconds;

  /// true = chạy hết phiên, false = dừng giữa chừng.
  final bool completed;

  /// Việc đang tập trung (tên task hoặc nhãn tự nhập).
  final String? label;

  /// Task liên kết (nếu chọn từ tab Công việc).
  final int? taskScheduleId;

  /// Tag tập trung đã chọn (nếu chọn từ danh sách tag) — dùng cho focus trend.
  final int? focusTagId;
  const PomodoroSessionTableData({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.focusSeconds,
    required this.plannedSeconds,
    required this.completed,
    this.label,
    this.taskScheduleId,
    this.focusTagId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['focus_seconds'] = Variable<int>(focusSeconds);
    map['planned_seconds'] = Variable<int>(plannedSeconds);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    if (!nullToAbsent || taskScheduleId != null) {
      map['task_schedule_id'] = Variable<int>(taskScheduleId);
    }
    if (!nullToAbsent || focusTagId != null) {
      map['focus_tag_id'] = Variable<int>(focusTagId);
    }
    return map;
  }

  PomodoroSessionTableCompanion toCompanion(bool nullToAbsent) {
    return PomodoroSessionTableCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      focusSeconds: Value(focusSeconds),
      plannedSeconds: Value(plannedSeconds),
      completed: Value(completed),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      taskScheduleId: taskScheduleId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskScheduleId),
      focusTagId: focusTagId == null && nullToAbsent
          ? const Value.absent()
          : Value(focusTagId),
    );
  }

  factory PomodoroSessionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PomodoroSessionTableData(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      focusSeconds: serializer.fromJson<int>(json['focusSeconds']),
      plannedSeconds: serializer.fromJson<int>(json['plannedSeconds']),
      completed: serializer.fromJson<bool>(json['completed']),
      label: serializer.fromJson<String?>(json['label']),
      taskScheduleId: serializer.fromJson<int?>(json['taskScheduleId']),
      focusTagId: serializer.fromJson<int?>(json['focusTagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'focusSeconds': serializer.toJson<int>(focusSeconds),
      'plannedSeconds': serializer.toJson<int>(plannedSeconds),
      'completed': serializer.toJson<bool>(completed),
      'label': serializer.toJson<String?>(label),
      'taskScheduleId': serializer.toJson<int?>(taskScheduleId),
      'focusTagId': serializer.toJson<int?>(focusTagId),
    };
  }

  PomodoroSessionTableData copyWith({
    int? id,
    DateTime? startedAt,
    DateTime? endedAt,
    int? focusSeconds,
    int? plannedSeconds,
    bool? completed,
    Value<String?> label = const Value.absent(),
    Value<int?> taskScheduleId = const Value.absent(),
    Value<int?> focusTagId = const Value.absent(),
  }) => PomodoroSessionTableData(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    focusSeconds: focusSeconds ?? this.focusSeconds,
    plannedSeconds: plannedSeconds ?? this.plannedSeconds,
    completed: completed ?? this.completed,
    label: label.present ? label.value : this.label,
    taskScheduleId: taskScheduleId.present
        ? taskScheduleId.value
        : this.taskScheduleId,
    focusTagId: focusTagId.present ? focusTagId.value : this.focusTagId,
  );
  PomodoroSessionTableData copyWithCompanion(
    PomodoroSessionTableCompanion data,
  ) {
    return PomodoroSessionTableData(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      focusSeconds: data.focusSeconds.present
          ? data.focusSeconds.value
          : this.focusSeconds,
      plannedSeconds: data.plannedSeconds.present
          ? data.plannedSeconds.value
          : this.plannedSeconds,
      completed: data.completed.present ? data.completed.value : this.completed,
      label: data.label.present ? data.label.value : this.label,
      taskScheduleId: data.taskScheduleId.present
          ? data.taskScheduleId.value
          : this.taskScheduleId,
      focusTagId: data.focusTagId.present
          ? data.focusTagId.value
          : this.focusTagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroSessionTableData(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('focusSeconds: $focusSeconds, ')
          ..write('plannedSeconds: $plannedSeconds, ')
          ..write('completed: $completed, ')
          ..write('label: $label, ')
          ..write('taskScheduleId: $taskScheduleId, ')
          ..write('focusTagId: $focusTagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAt,
    endedAt,
    focusSeconds,
    plannedSeconds,
    completed,
    label,
    taskScheduleId,
    focusTagId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PomodoroSessionTableData &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.focusSeconds == this.focusSeconds &&
          other.plannedSeconds == this.plannedSeconds &&
          other.completed == this.completed &&
          other.label == this.label &&
          other.taskScheduleId == this.taskScheduleId &&
          other.focusTagId == this.focusTagId);
}

class PomodoroSessionTableCompanion
    extends UpdateCompanion<PomodoroSessionTableData> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> focusSeconds;
  final Value<int> plannedSeconds;
  final Value<bool> completed;
  final Value<String?> label;
  final Value<int?> taskScheduleId;
  final Value<int?> focusTagId;
  const PomodoroSessionTableCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.focusSeconds = const Value.absent(),
    this.plannedSeconds = const Value.absent(),
    this.completed = const Value.absent(),
    this.label = const Value.absent(),
    this.taskScheduleId = const Value.absent(),
    this.focusTagId = const Value.absent(),
  });
  PomodoroSessionTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startedAt,
    required DateTime endedAt,
    required int focusSeconds,
    required int plannedSeconds,
    this.completed = const Value.absent(),
    this.label = const Value.absent(),
    this.taskScheduleId = const Value.absent(),
    this.focusTagId = const Value.absent(),
  }) : startedAt = Value(startedAt),
       endedAt = Value(endedAt),
       focusSeconds = Value(focusSeconds),
       plannedSeconds = Value(plannedSeconds);
  static Insertable<PomodoroSessionTableData> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? focusSeconds,
    Expression<int>? plannedSeconds,
    Expression<bool>? completed,
    Expression<String>? label,
    Expression<int>? taskScheduleId,
    Expression<int>? focusTagId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (focusSeconds != null) 'focus_seconds': focusSeconds,
      if (plannedSeconds != null) 'planned_seconds': plannedSeconds,
      if (completed != null) 'completed': completed,
      if (label != null) 'label': label,
      if (taskScheduleId != null) 'task_schedule_id': taskScheduleId,
      if (focusTagId != null) 'focus_tag_id': focusTagId,
    });
  }

  PomodoroSessionTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? focusSeconds,
    Value<int>? plannedSeconds,
    Value<bool>? completed,
    Value<String?>? label,
    Value<int?>? taskScheduleId,
    Value<int?>? focusTagId,
  }) {
    return PomodoroSessionTableCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      focusSeconds: focusSeconds ?? this.focusSeconds,
      plannedSeconds: plannedSeconds ?? this.plannedSeconds,
      completed: completed ?? this.completed,
      label: label ?? this.label,
      taskScheduleId: taskScheduleId ?? this.taskScheduleId,
      focusTagId: focusTagId ?? this.focusTagId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (focusSeconds.present) {
      map['focus_seconds'] = Variable<int>(focusSeconds.value);
    }
    if (plannedSeconds.present) {
      map['planned_seconds'] = Variable<int>(plannedSeconds.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (taskScheduleId.present) {
      map['task_schedule_id'] = Variable<int>(taskScheduleId.value);
    }
    if (focusTagId.present) {
      map['focus_tag_id'] = Variable<int>(focusTagId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroSessionTableCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('focusSeconds: $focusSeconds, ')
          ..write('plannedSeconds: $plannedSeconds, ')
          ..write('completed: $completed, ')
          ..write('label: $label, ')
          ..write('taskScheduleId: $taskScheduleId, ')
          ..write('focusTagId: $focusTagId')
          ..write(')'))
        .toString();
  }
}

class $FocusTagTableTable extends FocusTagTable
    with TableInfo<$FocusTagTableTable, FocusTagTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusTagTableTable(this.attachedDatabase, [this._alias]);
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
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    minutes,
    color,
    emoji,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_tag_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusTagTableData> instance, {
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
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    } else if (isInserting) {
      context.missing(_minutesMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusTagTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusTagTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $FocusTagTableTable createAlias(String alias) {
    return $FocusTagTableTable(attachedDatabase, alias);
  }
}

class FocusTagTableData extends DataClass
    implements Insertable<FocusTagTableData> {
  final int id;
  final String title;

  /// Độ dài phiên focus gợi ý (phút).
  final int minutes;

  /// Màu hiển thị (ARGB) — dùng cho chip và biểu đồ focus trend.
  final int color;

  /// Biểu tượng dạng emoji (không dùng IconData để không phá tree-shake icons).
  final String? emoji;

  /// Thứ tự hiển thị; nhỏ hơn đứng trước.
  final int sortOrder;
  const FocusTagTableData({
    required this.id,
    required this.title,
    required this.minutes,
    required this.color,
    this.emoji,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['minutes'] = Variable<int>(minutes);
    map['color'] = Variable<int>(color);
    if (!nullToAbsent || emoji != null) {
      map['emoji'] = Variable<String>(emoji);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  FocusTagTableCompanion toCompanion(bool nullToAbsent) {
    return FocusTagTableCompanion(
      id: Value(id),
      title: Value(title),
      minutes: Value(minutes),
      color: Value(color),
      emoji: emoji == null && nullToAbsent
          ? const Value.absent()
          : Value(emoji),
      sortOrder: Value(sortOrder),
    );
  }

  factory FocusTagTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusTagTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      minutes: serializer.fromJson<int>(json['minutes']),
      color: serializer.fromJson<int>(json['color']),
      emoji: serializer.fromJson<String?>(json['emoji']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'minutes': serializer.toJson<int>(minutes),
      'color': serializer.toJson<int>(color),
      'emoji': serializer.toJson<String?>(emoji),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  FocusTagTableData copyWith({
    int? id,
    String? title,
    int? minutes,
    int? color,
    Value<String?> emoji = const Value.absent(),
    int? sortOrder,
  }) => FocusTagTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    minutes: minutes ?? this.minutes,
    color: color ?? this.color,
    emoji: emoji.present ? emoji.value : this.emoji,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  FocusTagTableData copyWithCompanion(FocusTagTableCompanion data) {
    return FocusTagTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      color: data.color.present ? data.color.value : this.color,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusTagTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('minutes: $minutes, ')
          ..write('color: $color, ')
          ..write('emoji: $emoji, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, minutes, color, emoji, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusTagTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.minutes == this.minutes &&
          other.color == this.color &&
          other.emoji == this.emoji &&
          other.sortOrder == this.sortOrder);
}

class FocusTagTableCompanion extends UpdateCompanion<FocusTagTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> minutes;
  final Value<int> color;
  final Value<String?> emoji;
  final Value<int> sortOrder;
  const FocusTagTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.minutes = const Value.absent(),
    this.color = const Value.absent(),
    this.emoji = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  FocusTagTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int minutes,
    this.color = const Value.absent(),
    this.emoji = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : title = Value(title),
       minutes = Value(minutes);
  static Insertable<FocusTagTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? minutes,
    Expression<int>? color,
    Expression<String>? emoji,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (minutes != null) 'minutes': minutes,
      if (color != null) 'color': color,
      if (emoji != null) 'emoji': emoji,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  FocusTagTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? minutes,
    Value<int>? color,
    Value<String?>? emoji,
    Value<int>? sortOrder,
  }) {
    return FocusTagTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      minutes: minutes ?? this.minutes,
      color: color ?? this.color,
      emoji: emoji ?? this.emoji,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusTagTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('minutes: $minutes, ')
          ..write('color: $color, ')
          ..write('emoji: $emoji, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $TypingResultTableTable extends TypingResultTable
    with TableInfo<$TypingResultTableTable, TypingResultTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TypingResultTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 8,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 16,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _elapsedSecondsMeta = const VerificationMeta(
    'elapsedSeconds',
  );
  @override
  late final GeneratedColumn<int> elapsedSeconds = GeneratedColumn<int>(
    'elapsed_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typedCharsMeta = const VerificationMeta(
    'typedChars',
  );
  @override
  late final GeneratedColumn<int> typedChars = GeneratedColumn<int>(
    'typed_chars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctCharsMeta = const VerificationMeta(
    'correctChars',
  );
  @override
  late final GeneratedColumn<int> correctChars = GeneratedColumn<int>(
    'correct_chars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _incorrectCharsMeta = const VerificationMeta(
    'incorrectChars',
  );
  @override
  late final GeneratedColumn<int> incorrectChars = GeneratedColumn<int>(
    'incorrect_chars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctWordsMeta = const VerificationMeta(
    'correctWords',
  );
  @override
  late final GeneratedColumn<int> correctWords = GeneratedColumn<int>(
    'correct_words',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wpmMeta = const VerificationMeta('wpm');
  @override
  late final GeneratedColumn<double> wpm = GeneratedColumn<double>(
    'wpm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyMeta = const VerificationMeta(
    'accuracy',
  );
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
    'accuracy',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    takenAt,
    language,
    mode,
    durationSeconds,
    elapsedSeconds,
    typedChars,
    correctChars,
    incorrectChars,
    correctWords,
    wpm,
    accuracy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'typing_result_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TypingResultTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('elapsed_seconds')) {
      context.handle(
        _elapsedSecondsMeta,
        elapsedSeconds.isAcceptableOrUnknown(
          data['elapsed_seconds']!,
          _elapsedSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_elapsedSecondsMeta);
    }
    if (data.containsKey('typed_chars')) {
      context.handle(
        _typedCharsMeta,
        typedChars.isAcceptableOrUnknown(data['typed_chars']!, _typedCharsMeta),
      );
    } else if (isInserting) {
      context.missing(_typedCharsMeta);
    }
    if (data.containsKey('correct_chars')) {
      context.handle(
        _correctCharsMeta,
        correctChars.isAcceptableOrUnknown(
          data['correct_chars']!,
          _correctCharsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctCharsMeta);
    }
    if (data.containsKey('incorrect_chars')) {
      context.handle(
        _incorrectCharsMeta,
        incorrectChars.isAcceptableOrUnknown(
          data['incorrect_chars']!,
          _incorrectCharsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_incorrectCharsMeta);
    }
    if (data.containsKey('correct_words')) {
      context.handle(
        _correctWordsMeta,
        correctWords.isAcceptableOrUnknown(
          data['correct_words']!,
          _correctWordsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctWordsMeta);
    }
    if (data.containsKey('wpm')) {
      context.handle(
        _wpmMeta,
        wpm.isAcceptableOrUnknown(data['wpm']!, _wpmMeta),
      );
    } else if (isInserting) {
      context.missing(_wpmMeta);
    }
    if (data.containsKey('accuracy')) {
      context.handle(
        _accuracyMeta,
        accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta),
      );
    } else if (isInserting) {
      context.missing(_accuracyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TypingResultTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TypingResultTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      elapsedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_seconds'],
      )!,
      typedChars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}typed_chars'],
      )!,
      correctChars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_chars'],
      )!,
      incorrectChars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}incorrect_chars'],
      )!,
      correctWords: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_words'],
      )!,
      wpm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}wpm'],
      )!,
      accuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy'],
      )!,
    );
  }

  @override
  $TypingResultTableTable createAlias(String alias) {
    return $TypingResultTableTable(attachedDatabase, alias);
  }
}

class TypingResultTableData extends DataClass
    implements Insertable<TypingResultTableData> {
  final int id;

  /// Thời điểm kết thúc bài test.
  final DateTime takenAt;

  /// Mã ngôn ngữ đã gõ: 'en' | 'vi'.
  final String language;

  /// Nguồn nội dung: 'words' (từ ngẫu nhiên) | 'paragraph' (đoạn văn).
  final String mode;

  /// Độ dài bài test đã chọn (giây).
  final int durationSeconds;

  /// Số giây thực sự đã gõ (gõ xong đề sớm thì nhỏ hơn [durationSeconds]).
  final int elapsedSeconds;
  final int typedChars;
  final int correctChars;
  final int incorrectChars;

  /// Số từ gõ đúng trọn vẹn (khác với "từ" 5 ký tự dùng để tính WPM).
  final int correctWords;

  /// Tốc độ gõ (từ/phút; 1 từ = 5 ký tự ĐÚNG) và độ chính xác 0..1.
  final double wpm;
  final double accuracy;
  const TypingResultTableData({
    required this.id,
    required this.takenAt,
    required this.language,
    required this.mode,
    required this.durationSeconds,
    required this.elapsedSeconds,
    required this.typedChars,
    required this.correctChars,
    required this.incorrectChars,
    required this.correctWords,
    required this.wpm,
    required this.accuracy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['taken_at'] = Variable<DateTime>(takenAt);
    map['language'] = Variable<String>(language);
    map['mode'] = Variable<String>(mode);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['elapsed_seconds'] = Variable<int>(elapsedSeconds);
    map['typed_chars'] = Variable<int>(typedChars);
    map['correct_chars'] = Variable<int>(correctChars);
    map['incorrect_chars'] = Variable<int>(incorrectChars);
    map['correct_words'] = Variable<int>(correctWords);
    map['wpm'] = Variable<double>(wpm);
    map['accuracy'] = Variable<double>(accuracy);
    return map;
  }

  TypingResultTableCompanion toCompanion(bool nullToAbsent) {
    return TypingResultTableCompanion(
      id: Value(id),
      takenAt: Value(takenAt),
      language: Value(language),
      mode: Value(mode),
      durationSeconds: Value(durationSeconds),
      elapsedSeconds: Value(elapsedSeconds),
      typedChars: Value(typedChars),
      correctChars: Value(correctChars),
      incorrectChars: Value(incorrectChars),
      correctWords: Value(correctWords),
      wpm: Value(wpm),
      accuracy: Value(accuracy),
    );
  }

  factory TypingResultTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TypingResultTableData(
      id: serializer.fromJson<int>(json['id']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      language: serializer.fromJson<String>(json['language']),
      mode: serializer.fromJson<String>(json['mode']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      elapsedSeconds: serializer.fromJson<int>(json['elapsedSeconds']),
      typedChars: serializer.fromJson<int>(json['typedChars']),
      correctChars: serializer.fromJson<int>(json['correctChars']),
      incorrectChars: serializer.fromJson<int>(json['incorrectChars']),
      correctWords: serializer.fromJson<int>(json['correctWords']),
      wpm: serializer.fromJson<double>(json['wpm']),
      accuracy: serializer.fromJson<double>(json['accuracy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'language': serializer.toJson<String>(language),
      'mode': serializer.toJson<String>(mode),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'elapsedSeconds': serializer.toJson<int>(elapsedSeconds),
      'typedChars': serializer.toJson<int>(typedChars),
      'correctChars': serializer.toJson<int>(correctChars),
      'incorrectChars': serializer.toJson<int>(incorrectChars),
      'correctWords': serializer.toJson<int>(correctWords),
      'wpm': serializer.toJson<double>(wpm),
      'accuracy': serializer.toJson<double>(accuracy),
    };
  }

  TypingResultTableData copyWith({
    int? id,
    DateTime? takenAt,
    String? language,
    String? mode,
    int? durationSeconds,
    int? elapsedSeconds,
    int? typedChars,
    int? correctChars,
    int? incorrectChars,
    int? correctWords,
    double? wpm,
    double? accuracy,
  }) => TypingResultTableData(
    id: id ?? this.id,
    takenAt: takenAt ?? this.takenAt,
    language: language ?? this.language,
    mode: mode ?? this.mode,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    typedChars: typedChars ?? this.typedChars,
    correctChars: correctChars ?? this.correctChars,
    incorrectChars: incorrectChars ?? this.incorrectChars,
    correctWords: correctWords ?? this.correctWords,
    wpm: wpm ?? this.wpm,
    accuracy: accuracy ?? this.accuracy,
  );
  TypingResultTableData copyWithCompanion(TypingResultTableCompanion data) {
    return TypingResultTableData(
      id: data.id.present ? data.id.value : this.id,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      language: data.language.present ? data.language.value : this.language,
      mode: data.mode.present ? data.mode.value : this.mode,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      elapsedSeconds: data.elapsedSeconds.present
          ? data.elapsedSeconds.value
          : this.elapsedSeconds,
      typedChars: data.typedChars.present
          ? data.typedChars.value
          : this.typedChars,
      correctChars: data.correctChars.present
          ? data.correctChars.value
          : this.correctChars,
      incorrectChars: data.incorrectChars.present
          ? data.incorrectChars.value
          : this.incorrectChars,
      correctWords: data.correctWords.present
          ? data.correctWords.value
          : this.correctWords,
      wpm: data.wpm.present ? data.wpm.value : this.wpm,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TypingResultTableData(')
          ..write('id: $id, ')
          ..write('takenAt: $takenAt, ')
          ..write('language: $language, ')
          ..write('mode: $mode, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('typedChars: $typedChars, ')
          ..write('correctChars: $correctChars, ')
          ..write('incorrectChars: $incorrectChars, ')
          ..write('correctWords: $correctWords, ')
          ..write('wpm: $wpm, ')
          ..write('accuracy: $accuracy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    takenAt,
    language,
    mode,
    durationSeconds,
    elapsedSeconds,
    typedChars,
    correctChars,
    incorrectChars,
    correctWords,
    wpm,
    accuracy,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TypingResultTableData &&
          other.id == this.id &&
          other.takenAt == this.takenAt &&
          other.language == this.language &&
          other.mode == this.mode &&
          other.durationSeconds == this.durationSeconds &&
          other.elapsedSeconds == this.elapsedSeconds &&
          other.typedChars == this.typedChars &&
          other.correctChars == this.correctChars &&
          other.incorrectChars == this.incorrectChars &&
          other.correctWords == this.correctWords &&
          other.wpm == this.wpm &&
          other.accuracy == this.accuracy);
}

class TypingResultTableCompanion
    extends UpdateCompanion<TypingResultTableData> {
  final Value<int> id;
  final Value<DateTime> takenAt;
  final Value<String> language;
  final Value<String> mode;
  final Value<int> durationSeconds;
  final Value<int> elapsedSeconds;
  final Value<int> typedChars;
  final Value<int> correctChars;
  final Value<int> incorrectChars;
  final Value<int> correctWords;
  final Value<double> wpm;
  final Value<double> accuracy;
  const TypingResultTableCompanion({
    this.id = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.language = const Value.absent(),
    this.mode = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.typedChars = const Value.absent(),
    this.correctChars = const Value.absent(),
    this.incorrectChars = const Value.absent(),
    this.correctWords = const Value.absent(),
    this.wpm = const Value.absent(),
    this.accuracy = const Value.absent(),
  });
  TypingResultTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime takenAt,
    required String language,
    required String mode,
    required int durationSeconds,
    required int elapsedSeconds,
    required int typedChars,
    required int correctChars,
    required int incorrectChars,
    required int correctWords,
    required double wpm,
    required double accuracy,
  }) : takenAt = Value(takenAt),
       language = Value(language),
       mode = Value(mode),
       durationSeconds = Value(durationSeconds),
       elapsedSeconds = Value(elapsedSeconds),
       typedChars = Value(typedChars),
       correctChars = Value(correctChars),
       incorrectChars = Value(incorrectChars),
       correctWords = Value(correctWords),
       wpm = Value(wpm),
       accuracy = Value(accuracy);
  static Insertable<TypingResultTableData> custom({
    Expression<int>? id,
    Expression<DateTime>? takenAt,
    Expression<String>? language,
    Expression<String>? mode,
    Expression<int>? durationSeconds,
    Expression<int>? elapsedSeconds,
    Expression<int>? typedChars,
    Expression<int>? correctChars,
    Expression<int>? incorrectChars,
    Expression<int>? correctWords,
    Expression<double>? wpm,
    Expression<double>? accuracy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (takenAt != null) 'taken_at': takenAt,
      if (language != null) 'language': language,
      if (mode != null) 'mode': mode,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (elapsedSeconds != null) 'elapsed_seconds': elapsedSeconds,
      if (typedChars != null) 'typed_chars': typedChars,
      if (correctChars != null) 'correct_chars': correctChars,
      if (incorrectChars != null) 'incorrect_chars': incorrectChars,
      if (correctWords != null) 'correct_words': correctWords,
      if (wpm != null) 'wpm': wpm,
      if (accuracy != null) 'accuracy': accuracy,
    });
  }

  TypingResultTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? takenAt,
    Value<String>? language,
    Value<String>? mode,
    Value<int>? durationSeconds,
    Value<int>? elapsedSeconds,
    Value<int>? typedChars,
    Value<int>? correctChars,
    Value<int>? incorrectChars,
    Value<int>? correctWords,
    Value<double>? wpm,
    Value<double>? accuracy,
  }) {
    return TypingResultTableCompanion(
      id: id ?? this.id,
      takenAt: takenAt ?? this.takenAt,
      language: language ?? this.language,
      mode: mode ?? this.mode,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      typedChars: typedChars ?? this.typedChars,
      correctChars: correctChars ?? this.correctChars,
      incorrectChars: incorrectChars ?? this.incorrectChars,
      correctWords: correctWords ?? this.correctWords,
      wpm: wpm ?? this.wpm,
      accuracy: accuracy ?? this.accuracy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (elapsedSeconds.present) {
      map['elapsed_seconds'] = Variable<int>(elapsedSeconds.value);
    }
    if (typedChars.present) {
      map['typed_chars'] = Variable<int>(typedChars.value);
    }
    if (correctChars.present) {
      map['correct_chars'] = Variable<int>(correctChars.value);
    }
    if (incorrectChars.present) {
      map['incorrect_chars'] = Variable<int>(incorrectChars.value);
    }
    if (correctWords.present) {
      map['correct_words'] = Variable<int>(correctWords.value);
    }
    if (wpm.present) {
      map['wpm'] = Variable<double>(wpm.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TypingResultTableCompanion(')
          ..write('id: $id, ')
          ..write('takenAt: $takenAt, ')
          ..write('language: $language, ')
          ..write('mode: $mode, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('typedChars: $typedChars, ')
          ..write('correctChars: $correctChars, ')
          ..write('incorrectChars: $incorrectChars, ')
          ..write('correctWords: $correctWords, ')
          ..write('wpm: $wpm, ')
          ..write('accuracy: $accuracy')
          ..write(')'))
        .toString();
  }
}

class $TypingContentPackTableTable extends TypingContentPackTable
    with TableInfo<$TypingContentPackTableTable, TypingContentPackTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TypingContentPackTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 8,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordsJsonMeta = const VerificationMeta(
    'wordsJson',
  );
  @override
  late final GeneratedColumn<String> wordsJson = GeneratedColumn<String>(
    'words_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _paragraphsJsonMeta = const VerificationMeta(
    'paragraphsJson',
  );
  @override
  late final GeneratedColumn<String> paragraphsJson = GeneratedColumn<String>(
    'paragraphs_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    language,
    wordsJson,
    paragraphsJson,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'typing_content_pack_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TypingContentPackTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('words_json')) {
      context.handle(
        _wordsJsonMeta,
        wordsJson.isAcceptableOrUnknown(data['words_json']!, _wordsJsonMeta),
      );
    }
    if (data.containsKey('paragraphs_json')) {
      context.handle(
        _paragraphsJsonMeta,
        paragraphsJson.isAcceptableOrUnknown(
          data['paragraphs_json']!,
          _paragraphsJsonMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TypingContentPackTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TypingContentPackTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      wordsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}words_json'],
      )!,
      paragraphsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paragraphs_json'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $TypingContentPackTableTable createAlias(String alias) {
    return $TypingContentPackTableTable(attachedDatabase, alias);
  }
}

class TypingContentPackTableData extends DataClass
    implements Insertable<TypingContentPackTableData> {
  final int id;

  /// Tên gói để nhận ra trong danh sách (thường là tên file).
  final String name;

  /// Mã ngôn ngữ gói này thuộc về: 'en' | 'vi'.
  final String language;

  /// Danh sách từ, lưu dạng chuỗi JSON (mảng chuỗi).
  final String wordsJson;

  /// Danh sách đoạn văn, lưu dạng chuỗi JSON (mảng chuỗi).
  final String paragraphsJson;
  final DateTime addedAt;
  const TypingContentPackTableData({
    required this.id,
    required this.name,
    required this.language,
    required this.wordsJson,
    required this.paragraphsJson,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['language'] = Variable<String>(language);
    map['words_json'] = Variable<String>(wordsJson);
    map['paragraphs_json'] = Variable<String>(paragraphsJson);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  TypingContentPackTableCompanion toCompanion(bool nullToAbsent) {
    return TypingContentPackTableCompanion(
      id: Value(id),
      name: Value(name),
      language: Value(language),
      wordsJson: Value(wordsJson),
      paragraphsJson: Value(paragraphsJson),
      addedAt: Value(addedAt),
    );
  }

  factory TypingContentPackTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TypingContentPackTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      language: serializer.fromJson<String>(json['language']),
      wordsJson: serializer.fromJson<String>(json['wordsJson']),
      paragraphsJson: serializer.fromJson<String>(json['paragraphsJson']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'language': serializer.toJson<String>(language),
      'wordsJson': serializer.toJson<String>(wordsJson),
      'paragraphsJson': serializer.toJson<String>(paragraphsJson),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  TypingContentPackTableData copyWith({
    int? id,
    String? name,
    String? language,
    String? wordsJson,
    String? paragraphsJson,
    DateTime? addedAt,
  }) => TypingContentPackTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    language: language ?? this.language,
    wordsJson: wordsJson ?? this.wordsJson,
    paragraphsJson: paragraphsJson ?? this.paragraphsJson,
    addedAt: addedAt ?? this.addedAt,
  );
  TypingContentPackTableData copyWithCompanion(
    TypingContentPackTableCompanion data,
  ) {
    return TypingContentPackTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      language: data.language.present ? data.language.value : this.language,
      wordsJson: data.wordsJson.present ? data.wordsJson.value : this.wordsJson,
      paragraphsJson: data.paragraphsJson.present
          ? data.paragraphsJson.value
          : this.paragraphsJson,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TypingContentPackTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('language: $language, ')
          ..write('wordsJson: $wordsJson, ')
          ..write('paragraphsJson: $paragraphsJson, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, language, wordsJson, paragraphsJson, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TypingContentPackTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.language == this.language &&
          other.wordsJson == this.wordsJson &&
          other.paragraphsJson == this.paragraphsJson &&
          other.addedAt == this.addedAt);
}

class TypingContentPackTableCompanion
    extends UpdateCompanion<TypingContentPackTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> language;
  final Value<String> wordsJson;
  final Value<String> paragraphsJson;
  final Value<DateTime> addedAt;
  const TypingContentPackTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.language = const Value.absent(),
    this.wordsJson = const Value.absent(),
    this.paragraphsJson = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  TypingContentPackTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String language,
    this.wordsJson = const Value.absent(),
    this.paragraphsJson = const Value.absent(),
    required DateTime addedAt,
  }) : name = Value(name),
       language = Value(language),
       addedAt = Value(addedAt);
  static Insertable<TypingContentPackTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? language,
    Expression<String>? wordsJson,
    Expression<String>? paragraphsJson,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (language != null) 'language': language,
      if (wordsJson != null) 'words_json': wordsJson,
      if (paragraphsJson != null) 'paragraphs_json': paragraphsJson,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  TypingContentPackTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? language,
    Value<String>? wordsJson,
    Value<String>? paragraphsJson,
    Value<DateTime>? addedAt,
  }) {
    return TypingContentPackTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      language: language ?? this.language,
      wordsJson: wordsJson ?? this.wordsJson,
      paragraphsJson: paragraphsJson ?? this.paragraphsJson,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (wordsJson.present) {
      map['words_json'] = Variable<String>(wordsJson.value);
    }
    if (paragraphsJson.present) {
      map['paragraphs_json'] = Variable<String>(paragraphsJson.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TypingContentPackTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('language: $language, ')
          ..write('wordsJson: $wordsJson, ')
          ..write('paragraphsJson: $paragraphsJson, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $RemoteDeviceTableTable extends RemoteDeviceTable
    with TableInfo<$RemoteDeviceTableTable, RemoteDeviceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemoteDeviceTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, type, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'remote_device_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RemoteDeviceEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RemoteDeviceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RemoteDeviceEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RemoteDeviceTableTable createAlias(String alias) {
    return $RemoteDeviceTableTable(attachedDatabase, alias);
  }
}

class RemoteDeviceEntry extends DataClass
    implements Insertable<RemoteDeviceEntry> {
  final int id;
  final String name;
  final String type;
  final DateTime createdAt;
  const RemoteDeviceEntry({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RemoteDeviceTableCompanion toCompanion(bool nullToAbsent) {
    return RemoteDeviceTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      createdAt: Value(createdAt),
    );
  }

  factory RemoteDeviceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RemoteDeviceEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RemoteDeviceEntry copyWith({
    int? id,
    String? name,
    String? type,
    DateTime? createdAt,
  }) => RemoteDeviceEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
  );
  RemoteDeviceEntry copyWithCompanion(RemoteDeviceTableCompanion data) {
    return RemoteDeviceEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RemoteDeviceEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RemoteDeviceEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.createdAt == this.createdAt);
}

class RemoteDeviceTableCompanion extends UpdateCompanion<RemoteDeviceEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<DateTime> createdAt;
  const RemoteDeviceTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RemoteDeviceTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       type = Value(type);
  static Insertable<RemoteDeviceEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RemoteDeviceTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<DateTime>? createdAt,
  }) {
    return RemoteDeviceTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemoteDeviceTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
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
  late final $PomodoroSessionTableTable pomodoroSessionTable =
      $PomodoroSessionTableTable(this);
  late final $FocusTagTableTable focusTagTable = $FocusTagTableTable(this);
  late final $TypingResultTableTable typingResultTable =
      $TypingResultTableTable(this);
  late final $TypingContentPackTableTable typingContentPackTable =
      $TypingContentPackTableTable(this);
  late final $RemoteDeviceTableTable remoteDeviceTable =
      $RemoteDeviceTableTable(this);
  late final EventDao eventDao = EventDao(this as AppDatabase);
  late final TaskDao taskDao = TaskDao(this as AppDatabase);
  late final PomodoroDao pomodoroDao = PomodoroDao(this as AppDatabase);
  late final FocusTagDao focusTagDao = FocusTagDao(this as AppDatabase);
  late final TypingDao typingDao = TypingDao(this as AppDatabase);
  late final TypingContentDao typingContentDao = TypingContentDao(
    this as AppDatabase,
  );
  late final RemoteDeviceDao remoteDeviceDao = RemoteDeviceDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    eventTable,
    taskScheduleTable,
    taskCompletionTable,
    pomodoroSessionTable,
    focusTagTable,
    typingResultTable,
    typingContentPackTable,
    remoteDeviceTable,
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
typedef $$PomodoroSessionTableTableCreateCompanionBuilder =
    PomodoroSessionTableCompanion Function({
      Value<int> id,
      required DateTime startedAt,
      required DateTime endedAt,
      required int focusSeconds,
      required int plannedSeconds,
      Value<bool> completed,
      Value<String?> label,
      Value<int?> taskScheduleId,
      Value<int?> focusTagId,
    });
typedef $$PomodoroSessionTableTableUpdateCompanionBuilder =
    PomodoroSessionTableCompanion Function({
      Value<int> id,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> focusSeconds,
      Value<int> plannedSeconds,
      Value<bool> completed,
      Value<String?> label,
      Value<int?> taskScheduleId,
      Value<int?> focusTagId,
    });

class $$PomodoroSessionTableTableFilterComposer
    extends Composer<_$AppDatabase, $PomodoroSessionTableTable> {
  $$PomodoroSessionTableTableFilterComposer({
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

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusSeconds => $composableBuilder(
    column: $table.focusSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskScheduleId => $composableBuilder(
    column: $table.taskScheduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusTagId => $composableBuilder(
    column: $table.focusTagId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PomodoroSessionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PomodoroSessionTableTable> {
  $$PomodoroSessionTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusSeconds => $composableBuilder(
    column: $table.focusSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskScheduleId => $composableBuilder(
    column: $table.taskScheduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusTagId => $composableBuilder(
    column: $table.focusTagId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PomodoroSessionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PomodoroSessionTableTable> {
  $$PomodoroSessionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get focusSeconds => $composableBuilder(
    column: $table.focusSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get taskScheduleId => $composableBuilder(
    column: $table.taskScheduleId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get focusTagId => $composableBuilder(
    column: $table.focusTagId,
    builder: (column) => column,
  );
}

class $$PomodoroSessionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PomodoroSessionTableTable,
          PomodoroSessionTableData,
          $$PomodoroSessionTableTableFilterComposer,
          $$PomodoroSessionTableTableOrderingComposer,
          $$PomodoroSessionTableTableAnnotationComposer,
          $$PomodoroSessionTableTableCreateCompanionBuilder,
          $$PomodoroSessionTableTableUpdateCompanionBuilder,
          (
            PomodoroSessionTableData,
            BaseReferences<
              _$AppDatabase,
              $PomodoroSessionTableTable,
              PomodoroSessionTableData
            >,
          ),
          PomodoroSessionTableData,
          PrefetchHooks Function()
        > {
  $$PomodoroSessionTableTableTableManager(
    _$AppDatabase db,
    $PomodoroSessionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PomodoroSessionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PomodoroSessionTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PomodoroSessionTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> focusSeconds = const Value.absent(),
                Value<int> plannedSeconds = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int?> taskScheduleId = const Value.absent(),
                Value<int?> focusTagId = const Value.absent(),
              }) => PomodoroSessionTableCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                focusSeconds: focusSeconds,
                plannedSeconds: plannedSeconds,
                completed: completed,
                label: label,
                taskScheduleId: taskScheduleId,
                focusTagId: focusTagId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startedAt,
                required DateTime endedAt,
                required int focusSeconds,
                required int plannedSeconds,
                Value<bool> completed = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int?> taskScheduleId = const Value.absent(),
                Value<int?> focusTagId = const Value.absent(),
              }) => PomodoroSessionTableCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                focusSeconds: focusSeconds,
                plannedSeconds: plannedSeconds,
                completed: completed,
                label: label,
                taskScheduleId: taskScheduleId,
                focusTagId: focusTagId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PomodoroSessionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PomodoroSessionTableTable,
      PomodoroSessionTableData,
      $$PomodoroSessionTableTableFilterComposer,
      $$PomodoroSessionTableTableOrderingComposer,
      $$PomodoroSessionTableTableAnnotationComposer,
      $$PomodoroSessionTableTableCreateCompanionBuilder,
      $$PomodoroSessionTableTableUpdateCompanionBuilder,
      (
        PomodoroSessionTableData,
        BaseReferences<
          _$AppDatabase,
          $PomodoroSessionTableTable,
          PomodoroSessionTableData
        >,
      ),
      PomodoroSessionTableData,
      PrefetchHooks Function()
    >;
typedef $$FocusTagTableTableCreateCompanionBuilder =
    FocusTagTableCompanion Function({
      Value<int> id,
      required String title,
      required int minutes,
      Value<int> color,
      Value<String?> emoji,
      Value<int> sortOrder,
    });
typedef $$FocusTagTableTableUpdateCompanionBuilder =
    FocusTagTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int> minutes,
      Value<int> color,
      Value<String?> emoji,
      Value<int> sortOrder,
    });

class $$FocusTagTableTableFilterComposer
    extends Composer<_$AppDatabase, $FocusTagTableTable> {
  $$FocusTagTableTableFilterComposer({
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

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FocusTagTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusTagTableTable> {
  $$FocusTagTableTableOrderingComposer({
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

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FocusTagTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusTagTableTable> {
  $$FocusTagTableTableAnnotationComposer({
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

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$FocusTagTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusTagTableTable,
          FocusTagTableData,
          $$FocusTagTableTableFilterComposer,
          $$FocusTagTableTableOrderingComposer,
          $$FocusTagTableTableAnnotationComposer,
          $$FocusTagTableTableCreateCompanionBuilder,
          $$FocusTagTableTableUpdateCompanionBuilder,
          (
            FocusTagTableData,
            BaseReferences<
              _$AppDatabase,
              $FocusTagTableTable,
              FocusTagTableData
            >,
          ),
          FocusTagTableData,
          PrefetchHooks Function()
        > {
  $$FocusTagTableTableTableManager(_$AppDatabase db, $FocusTagTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusTagTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusTagTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusTagTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String?> emoji = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => FocusTagTableCompanion(
                id: id,
                title: title,
                minutes: minutes,
                color: color,
                emoji: emoji,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required int minutes,
                Value<int> color = const Value.absent(),
                Value<String?> emoji = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => FocusTagTableCompanion.insert(
                id: id,
                title: title,
                minutes: minutes,
                color: color,
                emoji: emoji,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FocusTagTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusTagTableTable,
      FocusTagTableData,
      $$FocusTagTableTableFilterComposer,
      $$FocusTagTableTableOrderingComposer,
      $$FocusTagTableTableAnnotationComposer,
      $$FocusTagTableTableCreateCompanionBuilder,
      $$FocusTagTableTableUpdateCompanionBuilder,
      (
        FocusTagTableData,
        BaseReferences<_$AppDatabase, $FocusTagTableTable, FocusTagTableData>,
      ),
      FocusTagTableData,
      PrefetchHooks Function()
    >;
typedef $$TypingResultTableTableCreateCompanionBuilder =
    TypingResultTableCompanion Function({
      Value<int> id,
      required DateTime takenAt,
      required String language,
      required String mode,
      required int durationSeconds,
      required int elapsedSeconds,
      required int typedChars,
      required int correctChars,
      required int incorrectChars,
      required int correctWords,
      required double wpm,
      required double accuracy,
    });
typedef $$TypingResultTableTableUpdateCompanionBuilder =
    TypingResultTableCompanion Function({
      Value<int> id,
      Value<DateTime> takenAt,
      Value<String> language,
      Value<String> mode,
      Value<int> durationSeconds,
      Value<int> elapsedSeconds,
      Value<int> typedChars,
      Value<int> correctChars,
      Value<int> incorrectChars,
      Value<int> correctWords,
      Value<double> wpm,
      Value<double> accuracy,
    });

class $$TypingResultTableTableFilterComposer
    extends Composer<_$AppDatabase, $TypingResultTableTable> {
  $$TypingResultTableTableFilterComposer({
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

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get typedChars => $composableBuilder(
    column: $table.typedChars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctChars => $composableBuilder(
    column: $table.correctChars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get incorrectChars => $composableBuilder(
    column: $table.incorrectChars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctWords => $composableBuilder(
    column: $table.correctWords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get wpm => $composableBuilder(
    column: $table.wpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TypingResultTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TypingResultTableTable> {
  $$TypingResultTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get typedChars => $composableBuilder(
    column: $table.typedChars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctChars => $composableBuilder(
    column: $table.correctChars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incorrectChars => $composableBuilder(
    column: $table.incorrectChars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctWords => $composableBuilder(
    column: $table.correctWords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get wpm => $composableBuilder(
    column: $table.wpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TypingResultTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TypingResultTableTable> {
  $$TypingResultTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get typedChars => $composableBuilder(
    column: $table.typedChars,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctChars => $composableBuilder(
    column: $table.correctChars,
    builder: (column) => column,
  );

  GeneratedColumn<int> get incorrectChars => $composableBuilder(
    column: $table.incorrectChars,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctWords => $composableBuilder(
    column: $table.correctWords,
    builder: (column) => column,
  );

  GeneratedColumn<double> get wpm =>
      $composableBuilder(column: $table.wpm, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);
}

class $$TypingResultTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TypingResultTableTable,
          TypingResultTableData,
          $$TypingResultTableTableFilterComposer,
          $$TypingResultTableTableOrderingComposer,
          $$TypingResultTableTableAnnotationComposer,
          $$TypingResultTableTableCreateCompanionBuilder,
          $$TypingResultTableTableUpdateCompanionBuilder,
          (
            TypingResultTableData,
            BaseReferences<
              _$AppDatabase,
              $TypingResultTableTable,
              TypingResultTableData
            >,
          ),
          TypingResultTableData,
          PrefetchHooks Function()
        > {
  $$TypingResultTableTableTableManager(
    _$AppDatabase db,
    $TypingResultTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TypingResultTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TypingResultTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TypingResultTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int> elapsedSeconds = const Value.absent(),
                Value<int> typedChars = const Value.absent(),
                Value<int> correctChars = const Value.absent(),
                Value<int> incorrectChars = const Value.absent(),
                Value<int> correctWords = const Value.absent(),
                Value<double> wpm = const Value.absent(),
                Value<double> accuracy = const Value.absent(),
              }) => TypingResultTableCompanion(
                id: id,
                takenAt: takenAt,
                language: language,
                mode: mode,
                durationSeconds: durationSeconds,
                elapsedSeconds: elapsedSeconds,
                typedChars: typedChars,
                correctChars: correctChars,
                incorrectChars: incorrectChars,
                correctWords: correctWords,
                wpm: wpm,
                accuracy: accuracy,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime takenAt,
                required String language,
                required String mode,
                required int durationSeconds,
                required int elapsedSeconds,
                required int typedChars,
                required int correctChars,
                required int incorrectChars,
                required int correctWords,
                required double wpm,
                required double accuracy,
              }) => TypingResultTableCompanion.insert(
                id: id,
                takenAt: takenAt,
                language: language,
                mode: mode,
                durationSeconds: durationSeconds,
                elapsedSeconds: elapsedSeconds,
                typedChars: typedChars,
                correctChars: correctChars,
                incorrectChars: incorrectChars,
                correctWords: correctWords,
                wpm: wpm,
                accuracy: accuracy,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TypingResultTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TypingResultTableTable,
      TypingResultTableData,
      $$TypingResultTableTableFilterComposer,
      $$TypingResultTableTableOrderingComposer,
      $$TypingResultTableTableAnnotationComposer,
      $$TypingResultTableTableCreateCompanionBuilder,
      $$TypingResultTableTableUpdateCompanionBuilder,
      (
        TypingResultTableData,
        BaseReferences<
          _$AppDatabase,
          $TypingResultTableTable,
          TypingResultTableData
        >,
      ),
      TypingResultTableData,
      PrefetchHooks Function()
    >;
typedef $$TypingContentPackTableTableCreateCompanionBuilder =
    TypingContentPackTableCompanion Function({
      Value<int> id,
      required String name,
      required String language,
      Value<String> wordsJson,
      Value<String> paragraphsJson,
      required DateTime addedAt,
    });
typedef $$TypingContentPackTableTableUpdateCompanionBuilder =
    TypingContentPackTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> language,
      Value<String> wordsJson,
      Value<String> paragraphsJson,
      Value<DateTime> addedAt,
    });

class $$TypingContentPackTableTableFilterComposer
    extends Composer<_$AppDatabase, $TypingContentPackTableTable> {
  $$TypingContentPackTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wordsJson => $composableBuilder(
    column: $table.wordsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paragraphsJson => $composableBuilder(
    column: $table.paragraphsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TypingContentPackTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TypingContentPackTableTable> {
  $$TypingContentPackTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wordsJson => $composableBuilder(
    column: $table.wordsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paragraphsJson => $composableBuilder(
    column: $table.paragraphsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TypingContentPackTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TypingContentPackTableTable> {
  $$TypingContentPackTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get wordsJson =>
      $composableBuilder(column: $table.wordsJson, builder: (column) => column);

  GeneratedColumn<String> get paragraphsJson => $composableBuilder(
    column: $table.paragraphsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$TypingContentPackTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TypingContentPackTableTable,
          TypingContentPackTableData,
          $$TypingContentPackTableTableFilterComposer,
          $$TypingContentPackTableTableOrderingComposer,
          $$TypingContentPackTableTableAnnotationComposer,
          $$TypingContentPackTableTableCreateCompanionBuilder,
          $$TypingContentPackTableTableUpdateCompanionBuilder,
          (
            TypingContentPackTableData,
            BaseReferences<
              _$AppDatabase,
              $TypingContentPackTableTable,
              TypingContentPackTableData
            >,
          ),
          TypingContentPackTableData,
          PrefetchHooks Function()
        > {
  $$TypingContentPackTableTableTableManager(
    _$AppDatabase db,
    $TypingContentPackTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TypingContentPackTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TypingContentPackTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TypingContentPackTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> wordsJson = const Value.absent(),
                Value<String> paragraphsJson = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
              }) => TypingContentPackTableCompanion(
                id: id,
                name: name,
                language: language,
                wordsJson: wordsJson,
                paragraphsJson: paragraphsJson,
                addedAt: addedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String language,
                Value<String> wordsJson = const Value.absent(),
                Value<String> paragraphsJson = const Value.absent(),
                required DateTime addedAt,
              }) => TypingContentPackTableCompanion.insert(
                id: id,
                name: name,
                language: language,
                wordsJson: wordsJson,
                paragraphsJson: paragraphsJson,
                addedAt: addedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TypingContentPackTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TypingContentPackTableTable,
      TypingContentPackTableData,
      $$TypingContentPackTableTableFilterComposer,
      $$TypingContentPackTableTableOrderingComposer,
      $$TypingContentPackTableTableAnnotationComposer,
      $$TypingContentPackTableTableCreateCompanionBuilder,
      $$TypingContentPackTableTableUpdateCompanionBuilder,
      (
        TypingContentPackTableData,
        BaseReferences<
          _$AppDatabase,
          $TypingContentPackTableTable,
          TypingContentPackTableData
        >,
      ),
      TypingContentPackTableData,
      PrefetchHooks Function()
    >;
typedef $$RemoteDeviceTableTableCreateCompanionBuilder =
    RemoteDeviceTableCompanion Function({
      Value<int> id,
      required String name,
      required String type,
      Value<DateTime> createdAt,
    });
typedef $$RemoteDeviceTableTableUpdateCompanionBuilder =
    RemoteDeviceTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> type,
      Value<DateTime> createdAt,
    });

class $$RemoteDeviceTableTableFilterComposer
    extends Composer<_$AppDatabase, $RemoteDeviceTableTable> {
  $$RemoteDeviceTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemoteDeviceTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RemoteDeviceTableTable> {
  $$RemoteDeviceTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemoteDeviceTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemoteDeviceTableTable> {
  $$RemoteDeviceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RemoteDeviceTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemoteDeviceTableTable,
          RemoteDeviceEntry,
          $$RemoteDeviceTableTableFilterComposer,
          $$RemoteDeviceTableTableOrderingComposer,
          $$RemoteDeviceTableTableAnnotationComposer,
          $$RemoteDeviceTableTableCreateCompanionBuilder,
          $$RemoteDeviceTableTableUpdateCompanionBuilder,
          (
            RemoteDeviceEntry,
            BaseReferences<
              _$AppDatabase,
              $RemoteDeviceTableTable,
              RemoteDeviceEntry
            >,
          ),
          RemoteDeviceEntry,
          PrefetchHooks Function()
        > {
  $$RemoteDeviceTableTableTableManager(
    _$AppDatabase db,
    $RemoteDeviceTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemoteDeviceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemoteDeviceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemoteDeviceTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RemoteDeviceTableCompanion(
                id: id,
                name: name,
                type: type,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String type,
                Value<DateTime> createdAt = const Value.absent(),
              }) => RemoteDeviceTableCompanion.insert(
                id: id,
                name: name,
                type: type,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemoteDeviceTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemoteDeviceTableTable,
      RemoteDeviceEntry,
      $$RemoteDeviceTableTableFilterComposer,
      $$RemoteDeviceTableTableOrderingComposer,
      $$RemoteDeviceTableTableAnnotationComposer,
      $$RemoteDeviceTableTableCreateCompanionBuilder,
      $$RemoteDeviceTableTableUpdateCompanionBuilder,
      (
        RemoteDeviceEntry,
        BaseReferences<
          _$AppDatabase,
          $RemoteDeviceTableTable,
          RemoteDeviceEntry
        >,
      ),
      RemoteDeviceEntry,
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
  $$PomodoroSessionTableTableTableManager get pomodoroSessionTable =>
      $$PomodoroSessionTableTableTableManager(_db, _db.pomodoroSessionTable);
  $$FocusTagTableTableTableManager get focusTagTable =>
      $$FocusTagTableTableTableManager(_db, _db.focusTagTable);
  $$TypingResultTableTableTableManager get typingResultTable =>
      $$TypingResultTableTableTableManager(_db, _db.typingResultTable);
  $$TypingContentPackTableTableTableManager get typingContentPackTable =>
      $$TypingContentPackTableTableTableManager(
        _db,
        _db.typingContentPackTable,
      );
  $$RemoteDeviceTableTableTableManager get remoteDeviceTable =>
      $$RemoteDeviceTableTableTableManager(_db, _db.remoteDeviceTable);
}
