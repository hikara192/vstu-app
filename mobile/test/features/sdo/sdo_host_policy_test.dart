import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/sdo/sdo_host_policy.dart';

void main() {
  group('isAllowedSdoUrl', () {
    test('разрешает домен vstu.by и его поддомены', () {
      expect(isAllowedSdoUrl('https://sdo.vstu.by/login/index.php'), isTrue);
      expect(isAllowedSdoUrl('https://vstu.by/'), isTrue);
      expect(isAllowedSdoUrl('https://www.vstu.by/'), isTrue);
      expect(isAllowedSdoUrl('http://sdo.vstu.by/'), isTrue);
    });

    test('отклоняет посторонние домены и похожие подделки', () {
      expect(isAllowedSdoUrl('https://evil.example/login'), isFalse);
      expect(isAllowedSdoUrl('https://sdo.vstu.by.evil.example/'), isFalse);
      expect(isAllowedSdoUrl('https://vstu.by.evil.example/'), isFalse);
      expect(isAllowedSdoUrl('https://notvstu.by/'), isFalse);
    });

    test('отклоняет небезопасные схемы', () {
      expect(isAllowedSdoUrl('javascript:alert(1)'), isFalse);
      expect(isAllowedSdoUrl('file:///etc/passwd'), isFalse);
      expect(isAllowedSdoUrl('intent://sdo.vstu.by'), isFalse);
    });

    test('отклоняет пустые и неразбираемые адреса', () {
      expect(isAllowedSdoUrl(''), isFalse);
      expect(isAllowedSdoUrl('не url'), isFalse);
    });
  });

  test('isAllowedSdoHost не зависит от регистра', () {
    expect(isAllowedSdoHost('SDO.VSTU.BY'), isTrue);
    expect(isAllowedSdoHost('EVIL.EXAMPLE'), isFalse);
  });
}
