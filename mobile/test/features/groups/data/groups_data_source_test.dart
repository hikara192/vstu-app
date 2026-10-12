import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/groups/data/group.dart';
import 'package:vstu_app/features/groups/data/groups_data_source.dart';

void main() {
  group('groupFromUni', () {
    test('parses a full payload including the specialty', () {
      final group = groupFromUni(<String, Object?>{
        'id': 42,
        'name': 'А-37',
        'facultyName': 'ФИТ',
        'facultyType': 'DAYTIME',
        'currentCourse': 2,
        'educationLevel': 'бакалавриат',
        'spec': <String, Object?>{
          'shortName': 'ПОИТ',
          'name': 'Программное обеспечение информационных технологий',
          'specCode': '1-40 01 01',
        },
      });

      expect(group.id, 42);
      expect(group.name, 'А-37');
      expect(group.facultyName, 'ФИТ');
      expect(group.facultyType, 'DAYTIME');
      expect(group.course, 2);
      expect(group.educationLevel, 'бакалавриат');
      expect(group.specShort, 'ПОИТ');
      expect(group.specName, 'Программное обеспечение информационных технологий');
      expect(group.specCode, '1-40 01 01');
    });

    test('tolerates missing optional fields', () {
      final group = groupFromUni(<String, Object?>{'id': 42, 'name': 'А-37'});

      expect(group.id, 42);
      expect(group.course, isNull);
      expect(group.specShort, isNull);
    });
  });

  group('searchGroups', () {
    final groups = <Group>[
      Group(
        id: 1,
        name: 'А-37',
        facultyName: 'ФИТ',
        specShort: 'ПОИТ',
        specName: 'Программное обеспечение информационных технологий',
        specCode: '1-40 01 01',
      ),
      Group(id: 2, name: 'ИС-21', facultyName: 'ФИТ'),
      Group(id: 3, name: 'Э-41', facultyName: 'ЭФ'),
    ];

    test('an empty query returns all groups', () {
      expect(searchGroups(groups, ''), hasLength(3));
    });

    test('matches case-insensitively by group name', () {
      final matches = searchGroups(groups, 'а-37');
      expect(matches, hasLength(1));
      expect(matches.single.id, 1);
    });

    test('matches by specialty code', () {
      final matches = searchGroups(groups, '1-40');
      expect(matches, hasLength(1));
      expect(matches.single.id, 1);
    });

    test('returns an empty list when nothing matches', () {
      expect(searchGroups(groups, 'zzz'), isEmpty);
    });
  });

  group('compareGroupNames', () {
    test('orders numbers numerically instead of lexicographically', () {
      expect(compareGroupNames('А-2', 'А-10'), lessThan(0));
      expect(compareGroupNames('А-10', 'А-2'), greaterThan(0));
    });

    test('orders by the text prefix first', () {
      expect(compareGroupNames('А-37', 'Б-1'), lessThan(0));
    });

    test('compares equal names as equal', () {
      expect(compareGroupNames('П-1', 'П-1'), 0);
    });
  });

  group('sortGroupsNaturally', () {
    test('sorts a mixed list by name', () {
      final sorted = sortGroupsNaturally(<Group>[
        Group(id: 10, name: 'А-10'),
        Group(id: 2, name: 'А-2'),
        Group(id: 37, name: 'Б-37'),
      ]);

      expect(
        sorted.map((group) => group.name).toList(),
        <String>['А-2', 'А-10', 'Б-37'],
      );
    });
  });
}