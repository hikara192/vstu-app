import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/core/utils/dates.dart';

void main() {
  group('dateOnly', () {
    test('strips the time-of-day part', () {
      expect(dateOnly(DateTime(2025, 3, 14, 13, 45, 59)), DateTime(2025, 3, 14));
    });
  });

  group('mondayOf', () {
    test('returns the Monday of the containing week', () {
      expect(mondayOf(DateTime(2025, 3, 14)), DateTime(2025, 3, 10));
    });

    test('returns the same day for a Monday', () {
      expect(mondayOf(DateTime(2025, 2, 3)), DateTime(2025, 2, 3));
    });
  });

  group('parseIsoDate', () {
    test('parses a date-only ISO string', () {
      expect(parseIsoDate('2025-02-03'), DateTime(2025, 2, 3));
    });

    test('takes the date part of a full ISO datetime', () {
      expect(parseIsoDate('2025-02-03T14:30:00.000Z'), DateTime(2025, 2, 3));
    });

    test('returns null for empty or malformed input', () {
      expect(parseIsoDate(''), isNull);
      expect(parseIsoDate(null), isNull);
      expect(parseIsoDate('not-a-date'), isNull);
    });
  });

  group('moment', () {
    test('combines a date with an hh:mm time', () {
      expect(
        moment(DateTime(2025, 2, 3), '9:50'),
        DateTime(2025, 2, 3, 9, 50),
      );
    });

    test('falls back to midnight for an empty time', () {
      expect(moment(DateTime(2025, 2, 3), ''), DateTime(2025, 2, 3));
    });
  });
}