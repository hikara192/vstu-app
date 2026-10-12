import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/sdo/domain/sdo_format.dart';

void main() {
  group('formatDeadline', () {
    final DateTime now = DateTime(2026, 10, 13, 9);

    test('сегодня и завтра подписаны словами', () {
      expect(
        formatDeadline(DateTime(2026, 10, 13, 23, 59), now: now),
        'Сегодня, 23:59',
      );
      expect(
        formatDeadline(DateTime(2026, 10, 14, 14), now: now),
        'Завтра, 14:00',
      );
      expect(
        formatDeadline(DateTime(2026, 10, 12, 8, 5), now: now),
        'Вчера, 08:05',
      );
    });

    test('далёкие даты показываются с месяцем', () {
      expect(
        formatDeadline(DateTime(2026, 10, 20, 12, 30), now: now),
        '20 октября, 12:30',
      );
    });

    test('час и минуты дополняются нулями', () {
      expect(
        formatDeadline(DateTime(2026, 10, 13, 7, 5), now: now),
        'Сегодня, 07:05',
      );
    });
  });

  group('formatShortDate', () {
    test('формат дд.мм.гггг', () {
      expect(formatShortDate(DateTime(2026, 10, 3)), '03.10.2026');
    });
  });
}
