import 'package:example_app/features/tracking/data/index.dart';
import 'package:example_app/features/tracking/domain/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late TrackingReminderRepositoryImpl repo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repo = TrackingReminderRepositoryImpl(
      TrackingReminderLocalDataSourceImpl(),
    );
  });

  test(
    'chưa lưu gì → bộ nhắc mặc định 20h<50, 21h<65, 22h<80, 23h<80',
    () async {
      final rules = (await repo.getRules()).getOrElse(() => throw 'failed');
      expect(rules, TrackingReminderRule.defaults);
      expect(rules.map((r) => (r.minutes ~/ 60, r.percent)), [
        (20, 50),
        (21, 65),
        (22, 80),
        (23, 80),
      ]);
    },
  );

  test(
    'lưu rồi đọc lại đúng, sắp theo giờ; danh sách rỗng vẫn giữ rỗng',
    () async {
      const rules = [
        TrackingReminderRule(minutes: 1320, percent: 80, enabled: false),
        TrackingReminderRule(
          minutes: 1140,
          comparison: ReminderComparison.equals,
          percent: 0,
        ),
      ];
      await repo.saveRules(rules);
      final read = (await repo.getRules()).getOrElse(() => throw 'failed');
      expect(read, [rules[1], rules[0]]);

      await repo.saveRules(const []);
      expect((await repo.getRules()).getOrElse(() => throw 'failed'), isEmpty);
    },
  );
}
