import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/schedule/domain/bells.dart';

void main() {
  group('timeSlots', () {
    test('defines the five standard lesson periods', () {
      expect(timeSlots, hasLength(5));
      expect(timeSlots[1], ('8:00', '9:35'));
      expect(timeSlots[2], ('9:50', '11:25'));
    });
  });

  group('resolveTimeSlot', () {
    test('returns the slot unchanged for a zero offset', () {
      expect(resolveTimeSlot(1, 0), ('8:00', '9:35'));
    });

    test('shifts the slot by a minute offset', () {
      expect(resolveTimeSlot(2, 10), ('10:00', '11:35'));
    });

    test('returns empty times for an unknown lesson number', () {
      expect(resolveTimeSlot(99, 0), ('', ''));
    });
  });
}