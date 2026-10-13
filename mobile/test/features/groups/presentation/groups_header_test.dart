import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vstu_app/core/config.dart';
import 'package:vstu_app/core/providers.dart';
import 'package:vstu_app/core/widgets/gradient_header.dart';
import 'package:vstu_app/features/groups/presentation/groups_header.dart';
import 'package:vstu_app/features/groups/presentation/groups_providers.dart';

/// Поднимает шапку так же, как это делает оболочка: подложку даёт вызывающий,
/// шапка отдаёт только содержимое.
Future<ProviderContainer> _pumpHeader(
  WidgetTester tester, {
  Map<String, Object> prefs = const <String, Object>{},
  void Function(ProviderContainer container)? before,
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final ProviderContainer container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
  );
  addTearDown(container.dispose);

  before?.call(container);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: Scaffold(body: GradientHeaderSurface(child: GroupsHeader())),
      ),
    ),
  );
  return container;
}

String _searchText(WidgetTester tester) =>
    tester.widget<SearchBar>(find.byType(SearchBar)).controller!.text;

void main() {
  testWidgets('шапка показывает поиск и подсказку, когда группа не выбрана', (
    WidgetTester tester,
  ) async {
    await _pumpHeader(tester);

    expect(find.text('VSTU HOME'), findsOneWidget);
    expect(find.text('Найдите свою учебную группу'), findsOneWidget);
    expect(find.byType(SearchBar), findsOneWidget);
    expect(find.byTooltip('Настройки'), findsOneWidget);
    expect(
      find.byTooltip('Назад'),
      findsNothing,
      reason: 'на верхнем уровне иерархии возвращаться некуда',
    );
  });

  testWidgets(
    'кнопка «Назад» появляется при выборе факультета и поднимает выше',
    (WidgetTester tester) async {
      final ProviderContainer container = await _pumpHeader(tester);

      container.read(groupsBrowseProvider.notifier).selectFaculty('ФИТ');
      await tester.pump();

      expect(
        find.text('ФИТ'),
        findsOneWidget,
        reason: 'факультет виден в шапке',
      );
      expect(find.byTooltip('Назад'), findsOneWidget);

      await tester.tap(find.byTooltip('Назад'));
      await tester.pump();

      expect(container.read(groupsBrowseProvider).faculty, isNull);
      expect(find.byTooltip('Назад'), findsNothing);
    },
  );

  testWidgets('поле поиска показывает уже сохранённый запрос', (
    WidgetTester tester,
  ) async {
    await _pumpHeader(
      tester,
      before: (ProviderContainer container) =>
          container.read(groupsQueryProvider.notifier).update('А-3'),
    );

    expect(_searchText(tester), 'А-3');
  });

  testWidgets('ввод обновляет провайдер, «Очистить» его сбрасывает', (
    WidgetTester tester,
  ) async {
    final ProviderContainer container = await _pumpHeader(tester);

    await tester.enterText(find.byType(SearchBar), 'А-3');
    await tester.pump();
    await tester.pump(
      AppConfig.searchDebounce + const Duration(milliseconds: 20),
    );

    expect(container.read(groupsQueryProvider), 'А-3');

    await tester.tap(find.byTooltip('Очистить'));
    await tester.pump();

    expect(container.read(groupsQueryProvider), '');
    expect(_searchText(tester), '');
  });

  testWidgets('подзаголовок показывает закреплённую группу и её расписание', (
    WidgetTester tester,
  ) async {
    await _pumpHeader(
      tester,
      prefs: <String, Object>{
        AppConfig.selectedGroupIdKey: 42,
        AppConfig.selectedGroupNameKey: 'А-3-21',
      },
    );

    expect(find.text('Моя группа: А-3-21'), findsOneWidget);
    expect(find.byTooltip('Расписание моей группы'), findsOneWidget);
  });
}
