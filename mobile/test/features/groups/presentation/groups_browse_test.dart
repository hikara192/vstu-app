import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/groups/presentation/groups_providers.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  GroupsBrowseState read() => container.read(groupsBrowseProvider);
  GroupsBrowse browse() => container.read(groupsBrowseProvider.notifier);

  test('выбор факультета и курса, up() снимает уровень за уровнем', () {
    expect(read().faculty, isNull);
    expect(read().course, isNull);

    browse().selectFaculty('ФИТ');
    expect(read().faculty, 'ФИТ');
    expect(read().course, isNull);

    browse().selectCourse(2);
    expect(read().faculty, 'ФИТ');
    expect(read().course, 2);

    browse().up();
    expect(read().course, isNull, reason: 'первый «назад» снимает курс');
    expect(read().faculty, 'ФИТ', reason: 'факультет остаётся выбранным');

    browse().up();
    expect(read().faculty, isNull, reason: 'второй «назад» снимает факультет');
  });

  test('выбор другого факультета сбрасывает курс', () {
    browse().selectFaculty('ФИТ');
    browse().selectCourse(2);

    browse().selectFaculty('ФЭМ');

    expect(read().faculty, 'ФЭМ');
    expect(read().course, isNull, reason: 'на новом факультете курса ещё нет');
  });

  test('reset() очищает выбор', () {
    browse().selectFaculty('ФИТ');
    browse().selectCourse(2);

    browse().reset();

    expect(read().faculty, isNull);
    expect(read().course, isNull);
  });

  test('up() на пустом выборе ничего не делает', () {
    browse().up();

    expect(read().faculty, isNull);
    expect(read().course, isNull);
  });

  test('состояние сравнивается по значению', () {
    expect(
      const GroupsBrowseState(faculty: 'ФИТ', course: 2),
      const GroupsBrowseState(faculty: 'ФИТ', course: 2),
    );
    expect(
      const GroupsBrowseState(faculty: 'ФИТ', course: 2).hashCode,
      const GroupsBrowseState(faculty: 'ФИТ', course: 2).hashCode,
    );
    expect(
      const GroupsBrowseState(faculty: 'ФИТ'),
      isNot(const GroupsBrowseState(faculty: 'ФИТ', course: 2)),
    );
  });
}
