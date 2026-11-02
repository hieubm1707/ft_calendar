import '../../domain/index.dart';

extension TrackingReminderRuleJson on TrackingReminderRule {
  Map<String, dynamic> toJson() => {
    'minutes': minutes,
    'comparison': comparison.name,
    'percent': percent,
    'enabled': enabled,
  };
}

TrackingReminderRule trackingReminderRuleFromJson(Map<String, dynamic> json) =>
    TrackingReminderRule(
      minutes: json['minutes'] as int,
      comparison: ReminderComparison.values.firstWhere(
        (c) => c.name == json['comparison'],
        orElse: () => ReminderComparison.lessThan,
      ),
      percent: json['percent'] as int,
      enabled: json['enabled'] as bool? ?? true,
    );
