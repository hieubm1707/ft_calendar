import 'package:drift/drift.dart';

@DataClassName('RemoteDeviceEntry')
class RemoteDeviceTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()(); // 'tv', 'air_conditioner', 'fan'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
