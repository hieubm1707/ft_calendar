class BrandInfo {
  final String name;
  final String hexCode;
  final String protocol;

  const BrandInfo({
    required this.name,
    required this.hexCode,
    required this.protocol,
  });
}

class RemoteBrandData {
  static const Map<String, List<BrandInfo>> brandsByType = {
    'tv': [
      BrandInfo(name: 'LG', hexCode: '0x20DF10EF', protocol: 'NEC 32-bit'),
      BrandInfo(name: 'Samsung', hexCode: '0xE0E040BF', protocol: 'Samsung 32-bit'),
      BrandInfo(name: 'Sony', hexCode: '0xA90', protocol: 'Sony SIRC 12-bit'),
      BrandInfo(name: 'Panasonic', hexCode: '0x40040100', protocol: 'Panasonic Kaseikyo'),
      BrandInfo(name: 'TCL', hexCode: '0x29B700FF', protocol: 'NEC 32-bit'),
      BrandInfo(name: 'Xiaomi / Android TV', hexCode: '0x800F040C', protocol: 'RC6 / Bluetooth'),
      BrandInfo(name: 'Hãng Khác / OEM', hexCode: 'AUTO_SCAN', protocol: 'Tự động quét (20 mã)'),
    ],
    'air_conditioner': [
      BrandInfo(name: 'Daikin', hexCode: '0x11DA2700', protocol: 'Daikin 154-bit'),
      BrandInfo(name: 'Panasonic', hexCode: '0x0220E004', protocol: 'Panasonic AC'),
      BrandInfo(name: 'Mitsubishi', hexCode: '0x23CB2601', protocol: 'Mitsubishi 112-bit'),
      BrandInfo(name: 'Gree', hexCode: '0x31000000', protocol: 'Gree AC'),
      BrandInfo(name: 'Casper', hexCode: '0x10AF00FF', protocol: 'NEC AC'),
      BrandInfo(name: 'Toshiba', hexCode: '0xF20D03FC', protocol: 'Toshiba 48-bit'),
      BrandInfo(name: 'Hãng Khác / OEM', hexCode: 'AUTO_SCAN', protocol: 'Tự động quét (20 mã)'),
    ],
    'fan': [
      BrandInfo(name: 'Senko', hexCode: '0xFA001122', protocol: 'NEC Fan'),
      BrandInfo(name: 'Panasonic', hexCode: '0x0288E001', protocol: 'Panasonic Fan'),
      BrandInfo(name: 'KDK', hexCode: '0x0288E002', protocol: 'KDK Fan'),
      BrandInfo(name: 'Asia', hexCode: '0xFA003344', protocol: 'NEC Fan'),
      BrandInfo(name: 'Toshiba Fan', hexCode: '0x61A0F00F', protocol: 'Toshiba Fan'),
      BrandInfo(name: 'Mitsubishi Fan', hexCode: '0xC4D300FF', protocol: 'Mitsubishi Fan'),
      BrandInfo(name: 'Quạt Không Tên / Hãng Khác', hexCode: 'AUTO_SCAN', protocol: 'Tự động quét (20 mã)'),
    ],
  };

  /// Danh sách 20 mã HEX tần số phổ thông cho thiết bị OEM không tên
  static const List<String> genericAutoScanCodes = [
    '0x00FF02FD', '0x00FFA25D', '0x00FF629D', '0x00FFE21D',
    '0x00FF22DD', '0x00FF02FD', '0x00FFC23D', '0x00FFE01F',
    '0xBF00FF00', '0xBF00FE01', '0xBF00FD02', '0xBF00FC03',
    '0x10AF10EF', '0x10AF20DF', '0xFA001122', '0xFA003344',
    '0x61A0F00F', '0xC4D300FF', '0x807F10EF', '0x807F20DF',
  ];
}
