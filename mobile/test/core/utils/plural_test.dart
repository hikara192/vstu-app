import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/core/utils/plural.dart';

void main() {
  group('plural', () {
    test('picks the right Russian form by count', () {
      expect(plural(1, 'пара', 'пары', 'пар'), 'пара');
      expect(plural(2, 'пара', 'пары', 'пар'), 'пары');
      expect(plural(5, 'пара', 'пары', 'пар'), 'пар');
    });

    test('uses the many-form for teens', () {
      expect(plural(11, 'пара', 'пары', 'пар'), 'пар');
      expect(plural(14, 'пара', 'пары', 'пар'), 'пар');
      expect(plural(111, 'пара', 'пары', 'пар'), 'пар');
    });

    test('re-applies singular after a hundred', () {
      expect(plural(21, 'пара', 'пары', 'пар'), 'пара');
      expect(plural(26, 'пара', 'пары', 'пар'), 'пар');
    });
  });

  group('lessonsLabel', () {
    test('formats counts of lessons', () {
      expect(lessonsLabel(0), 'занятий нет');
      expect(lessonsLabel(1), '1 пара');
      expect(lessonsLabel(2), '2 пары');
      expect(lessonsLabel(5), '5 пар');
    });
  });

  group('groupsLabel', () {
    test('formats counts of groups', () {
      expect(groupsLabel(0), 'ничего не найдено');
      expect(groupsLabel(1), '1 группа');
      expect(groupsLabel(3), '3 группы');
    });
  });

  group('durationLabel', () {
    test('formats plain minutes', () {
      expect(durationLabel(const Duration(minutes: 45)), '45 минут');
    });

    test('formats whole hours', () {
      expect(durationLabel(const Duration(minutes: 60)), '1 час');
    });

    test('formats hours and minutes', () {
      expect(durationLabel(const Duration(minutes: 75)), '1 час 15 минут');
      expect(
        durationLabel(const Duration(hours: 2, minutes: 5)),
        '2 часа 5 минут',
      );
    });
  });

  group('remainingLabel', () {
    test('says a lesson is ending when under a minute remains', () {
      expect(remainingLabel(const Duration(seconds: 30)), 'пара заканчивается');
    });

    test('formats a full remaining duration', () {
      expect(remainingLabel(const Duration(minutes: 1)), 'осталось 1 минута');
    });
  });
}