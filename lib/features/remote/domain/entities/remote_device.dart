enum RemoteType {
  tv,
  airConditioner,
  fan;

  String get displayName {
    switch (this) {
      case RemoteType.tv:
        return 'Tivi';
      case RemoteType.airConditioner:
        return 'Máy lạnh';
      case RemoteType.fan:
        return 'Máy quạt';
    }
  }

  String get code {
    switch (this) {
      case RemoteType.tv:
        return 'tv';
      case RemoteType.airConditioner:
        return 'air_conditioner';
      case RemoteType.fan:
        return 'fan';
    }
  }

  static RemoteType fromCode(String code) {
    switch (code) {
      case 'tv':
        return RemoteType.tv;
      case 'air_conditioner':
        return RemoteType.airConditioner;
      case 'fan':
        return RemoteType.fan;
      default:
        return RemoteType.tv;
    }
  }
}

class RemoteDevice {
  final int id;
  final String name;
  final RemoteType type;
  final DateTime createdAt;

  const RemoteDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
  });
}
