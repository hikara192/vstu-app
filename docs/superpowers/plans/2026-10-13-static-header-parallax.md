# Неподвижная шапка + параллакс-переход: план реализации

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Шапка (`GradientHeader`) перестаёт уезжать вместе с экраном — она живёт в постоянной оболочке, а переход между группами и расписанием применяется только к содержанию и выглядит как параллакс-сдвиг.

**Architecture:** Группы и расписание переезжают под общий `ShellRoute`. Оболочка `AppShell` рисует градиентную подложку шапки и подменяет её содержимое (заголовок/подзаголовок/действия/поиск ↔ неделя) кроссфейдом на месте; страницы отдают только содержание. Переход из темы — новый `ParallaxPageTransitionsBuilder`: входящее содержание едет справа на полную ширину, уходящее — на четверть и притухает.

**Tech Stack:** Flutter (Material из `package:flutter/material.dart`), Riverpod, go_router 18.0.2, shared_preferences.

**Spec:** дизайн согласован в сессии; его решения зафиксированы ниже в разделах «Проверено заранее» и «Решения дизайна» — отдельного файла-спеки нет.

## Проверено заранее (эмпирически, зондами)

1. `PopScope` внутри страницы, живущей во вложенном `Navigator` под `ShellRoute`, **перехватывает** системный «назад» (`handlePopRoute` → `handled=true`, адрес остаётся `/`, колбэк срабатывает). Значит иерархия «факультет → курс» переживёт перенос под оболочку.
2. Внутри оболочки нажатая страница **получает переход из темы** (середина перехода: `dx ≈ 0.11`), а хром (`Column` оболочки) **не попадает** ни в один `FractionalTranslation`. Значит «шапка стоит, содержание едет» достигается самой конструкцией `ShellRoute`.

## Решения дизайна

- **Настройки и СДО остаются вне оболочки.** Настройки — отдельный полноэкранный маршрут: их оборачивает `ThemeRevealArea`, который снимает снимок всего своего поддерева и рисует раскрытие круга. Если вынести их шапку в оболочку, круг раскрытия перестанет накрывать шапку и смена темы «вспыхнет» сверху. СДО — раздел со своей шапкой, пушится поверх оболочки.
- **Страница оболочки остаётся без перехода** (go_router отдаёт для неё `NoTransitionPage`). Это осознанно: при пуше настроек поверх оболочки хром обязан стоять на месте, а не уезжать.
- **Кроссфейд содержимого шапки.** Шапка физически не двигается, но её содержимое обязано меняться (заголовок, поиск ↔ неделя). Мгновенная подмена выглядит рывком, поэтому содержимое меняется кроссфейдом (`AnimatedSwitcher`, 180 мс) с анимацией высоты (`AnimatedSize`, 220 мс).
- **Состояние обзора групп переносится в провайдер** (`groupsBrowseProvider`): и шапка, и список читают его. Следствие — при возврате из расписания список групп открывается на том же уровне, что и был (раньше состояние сбрасывалось вместе с экраном). Это намеренное изменение поведения.
- **Поле поиска инициализируется из `groupsQueryProvider`.** Запрос в провайдере переживает уход с экрана, поэтому поле обязано показать его — иначе получаем отфильтрованный список с пустой строкой поиска.
- **Геометрия перехода:** входящее содержание — с `+1.0` ширины до `0`; уходящее — до `-0.25` ширины и затемняется на `0.12`. Ход уходящего и затемнение — это и есть «параллакс»: экраны едут с разной скоростью, из-за чего возникает глубина.

## Global Constraints

- Приложение строит `MaterialApp.router` из `package:flutter/material.dart`. go_router 18 определяет тип приложения через `package:material_ui` и при несовпадении **молча** отдаёт `NoTransitionPage` (нулевая длительность, пустой `transitionsBuilder`). Поэтому **каждый** маршрут задаётся явным `pageBuilder: ... MaterialPage(...)` через существующий `_materialPage` в `lib/app/router.dart`; на `builder:` не переходить.
- Переход не имеет права перестраивать поддерево страницы каждый кадр: `AnimatedBuilder(child: child)` и обёртки, не создающие `child` внутри `builder`.
- `themeAnimationDuration: Duration.zero` в `lib/app/app.dart` остаётся как есть.
- Никаких тяжёлых эффектов (blur, backdrop) в переходе — телефон 90/120 Гц, просадки видно сразу.
- **Коммитов нет.** Владелец коммитит сам. Шаги задач заканчиваются прогоном тестов и `flutter analyze`, а не `git commit`.
- Комментарии и док-комментарии — по-русски, как в окружающем коде. Форматирование — `dart format`.
- После каждой задачи: `flutter test` зелёный (162 существующих теста + новые), `flutter analyze` показывает только 7 известных info в `lib/features/sdo/presentation/*`.

## Review Focus

1. **Открытие настроек или СДО поверх оболочки.** Ожидание: полноэкранный маршрут рисуется поверх оболочки, а не внутри неё (иначе появятся две шапки одна под другой). Проверяется в задаче 6.
2. **Системный «назад» на верхнем уровне оболочки, когда выбран факультет или курс.** Ожидание: снимается один уровень иерархии, приложение не закрывается. Проверяется в задаче 7.
3. **Строка поиска после ухода на расписание и возврата.** Ожидание: в поле виден сохранённый запрос, а не пустая строка над отфильтрованным списком. Проверяется в задаче 6.
4. **Нажатия в шапке (СДО, настройки, «назад»).** Ожидание: они работают в корневом навигаторе, а не во вложенном. Проверяется в задаче 6.
5. **Слайд тяжёлого расписания.** Ожидание: поддерево страницы не перестраивается каждый кадр перехода. Проверяется в задаче 1.

---

### Задача 1: Переход-параллакс вместо shared axis

**Files:**
- Create: `mobile/lib/app/parallax_page_transitions.dart`
- Delete: `mobile/lib/app/shared_axis_page_transitions.dart`
- Modify: `mobile/lib/app/theme.dart:4` (import), `mobile/lib/app/theme.dart:137-140` (builder)
- Modify: `mobile/test/app/app_theme_test.dart` (ожидаемый тип билдера)
- Modify: `mobile/test/app/router_page_transitions_test.dart:11,77` (импорт и верхняя граница `dx`)
- Delete: `mobile/test/app/shared_axis_page_transitions_test.dart`
- Test: `mobile/test/app/parallax_page_transitions_test.dart`

**Interfaces:**
- Produces: `class ParallaxPageTransitionsBuilder extends PageTransitionsBuilder` с `const ParallaxPageTransitionsBuilder()` и публичными константами `kDuration` (320 мс), `kOutgoingFraction` (0.25), `kScrimOpacity` (0.12), `kCurve` (`Curves.easeInOutCubicEmphasized`).

- [ ] **Step 1: Написать падающий тест**

```dart
// test/app/parallax_page_transitions_test.dart
// Материал без go_router: проверяем чистую геометрию билдера.
// Страница №2 пушится MaterialPageRoute — на Android он берёт переход из темы.

/// dx страницы относительно её места: 0 — на месте, 1 — целиком справа за кадром.
double? _dxOf(WidgetTester tester, Type screen) { /* как в router_page_transitions_test.dart */ }

testWidgets('входящий экран едет справа на полную ширину и доезжает до нуля', ...) {
  // tap → pump(16ms) → dx(t=60мс) > 0 и убывает; через 400 мс ≈ 0
}

testWidgets('уходящий экран уезжает на четверть и притухает', ...) {
  // после завершения перехода у первой страницы dx ≈ -kOutgoingFraction
  // и над ней DecoratedBox с DecorationPosition.foreground, alpha ≈ kScrimOpacity
}

testWidgets('поддерево страницы не перестраивается во время перехода', ...) {
  // тело второй страницы — виджет со счётчиком сборок;
  // прогоняем переход шагами по 16 мс до конца → сборок ровно 1
}
```

- [ ] **Step 2: Убедиться, что тест падает**

Run: `flutter test test/app/parallax_page_transitions_test.dart`
Expected: FAIL — `ParallaxPageTransitionsBuilder` не определён (ошибка компиляции).

- [ ] **Step 3: Реализовать переход**

`lib/app/parallax_page_transitions.dart`: `ParallaxPageTransitionsBuilder` с `transitionDuration => kDuration`, возвращающий `_ParallaxPageTransition` (`StatelessWidget`, поля `animation`, `secondaryAnimation`, `child`). Геометрия (это и есть решение, которое нельзя вывести из сигнатуры):

```dart
final double enter = kCurve.transform(animation.value);          // 0 — за кадром справа, 1 — на месте
final double under = kCurve.transform(secondaryAnimation.value);  // 0 — не перекрыт, 1 — ушёл под верхний
final double dx = (1 - enter) - kOutgoingFraction * under;
final double scrim = kScrimOpacity * under;
```

`AnimatedBuilder(animation: Listenable.merge([animation, secondaryAnimation]), child: child, builder: ...)`: оборачивает `child` в `FractionalTranslation(translation: Offset(dx, 0))`, а при `scrim > 0` — ещё в `DecoratedBox(position: DecorationPosition.foreground, decoration: BoxDecoration(color: Colors.black.withValues(alpha: scrim)))`. При `enter == 1 && under == 0` (обычное состояние) `dx == 0` и `scrim == 0` — кадр не отличается от обычной отрисовки.

- [ ] **Step 4: Заменить билдер в теме и удалить прежний**

В `theme.dart` — импорт и `TargetPlatform.android: ParallaxPageTransitionsBuilder()`. Удалить `shared_axis_page_transitions.dart` и `shared_axis_page_transitions_test.dart`. В `app_theme_test.dart` заменить ожидаемый тип на `ParallaxPageTransitionsBuilder`. В `router_page_transitions_test.dart` — импорт и заменить `lessThan(SharedAxisPageTransitionsBuilder.kSlideFraction)` на `lessThan(1)` (настройки теперь въезжают на полную ширину), поправив `reason`.

- [ ] **Step 5: Прогнать тесты и анализатор**

Run: `flutter test` → все зелёные. `flutter analyze` → только 7 известных info.

---

### Задача 2: Разделить шапку на подложку и содержимое

**Files:**
- Modify: `mobile/lib/core/widgets/gradient_header.dart`
- Test: `mobile/test/core/widgets/gradient_header_test.dart`

**Interfaces:**
- Produces: `GradientHeaderSurface({required Widget child})` — градиентная подложка с радиусом, тенью, `AnnotatedRegion` и `IconTheme` (белые иконки); `GradientHeaderContent({required String title, String? subtitle, Widget? leading, List<Widget> actions = const [], Widget? child})` — внутренний `Column` (строка с заголовком/подзаголовком/действиями + необязательный `child`).
- Preserves: `GradientHeader` с прежней сигнатурой (`title`, `subtitle`, `leading`, `actions`, `child`) — его используют настройки, СДО и тесты. Его `build` теперь `GradientHeaderSurface(child: GradientHeaderContent(...))`.

- [ ] **Step 1: Написать падающий тест**

```dart
testWidgets('GradientHeader рисует заголовок и действия внутри подложки', ...) {
  // GradientHeader(title: 'VSTU HOME', subtitle: '...', actions: [Icon(Icons.tune_rounded)])
  // expect: find.text('VSTU HOME'), find.text('...'), find.byIcon(...)
  // expect(find.byType(GradientHeaderSurface), findsOneWidget);
  // expect(find.byType(GradientHeaderContent), findsOneWidget);
}

testWidgets('GradientHeaderSurface принимает произвольное содержимое', ...) {
  // GradientHeaderSurface(child: Text('произвольное')) → текст виден,
  // над ним Container с BoxDecoration.gradient
}
```

- [ ] **Step 2: Убедиться, что тест падает**

Run: `flutter test test/core/widgets/gradient_header_test.dart`
Expected: FAIL — `GradientHeaderSurface` не определён.

- [ ] **Step 3: Разделить виджет**

Перенести в `GradientHeaderSurface` всё, что отвечает за подложку: `AnnotatedRegion<SystemUiOverlayStyle>`, `Container` с `heroGradient`, `BorderRadius.vertical(bottom: Radius.circular(26))`, тень, `padding: EdgeInsets.fromLTRB(16, topInset + 12, 16, 18)` (`topInset = MediaQuery.paddingOf(context).top`) и `IconTheme.merge` с белыми иконками. В `GradientHeaderContent` — нынешний `Column` (строка с `leading`, заголовком, подзаголовком и `actions`; `child` под `Padding(top: 16)`). `GradientHeader.build` собирает одно из другого. Внешний вид и сигнатура `GradientHeader` не меняются.

- [ ] **Step 4: Прогнать тесты и анализатор**

Run: `flutter test` → зелёные (настройки и СДО используют `GradientHeader` без правок). `flutter analyze` → 7 info.

---

### Задача 3: Состояние обзора групп в провайдере

**Files:**
- Modify: `mobile/lib/features/groups/presentation/groups_providers.dart`
- Test: `mobile/test/features/groups/presentation/groups_browse_test.dart`

**Interfaces:**
- Produces: `class GroupsBrowseState` (`const GroupsBrowseState({String? faculty, int? course})`, геттеры `faculty`, `course`, `==`/`hashCode`) и `groupsBrowseProvider = NotifierProvider<GroupsBrowse, GroupsBrowseState>` с методами `selectFaculty(String name)` (сбрасывает курс), `selectCourse(int course)`, `up()` (снимает курс, иначе факультет), `reset()`.

- [ ] **Step 1: Написать падающий тест**

```dart
// ProviderContainer() без оверрайдов: провайдер самодостаточен.
test('выбор факультета и курса, up() снимает уровень за уровнем', ...) {
  // selectFaculty('ФИТ') → faculty='ФИТ', course=null
  // selectCourse(2) → faculty='ФИТ', course=2
  // up() → course=null; up() → faculty=null
}

test('выбор другого факультета сбрасывает курс', ...) { /* selectCourse(2) → selectFaculty('ФЭМ') → course=null */ }
test('reset() очищает выбор', ...) {}
```

- [ ] **Step 2: Убедиться, что тест падает**

Run: `flutter test test/features/groups/presentation/groups_browse_test.dart`
Expected: FAIL — `groupsBrowseProvider` не определён.

- [ ] **Step 3: Реализовать**

В `groups_providers.dart` рядом с `groupsQueryProvider`: `GroupsBrowseState` (`@immutable`, поля `faculty`/`course`) и `GroupsBrowse extends Notifier<GroupsBrowseState>`, `build() => const GroupsBrowseState()`. Логика уровней — из шага 1.

- [ ] **Step 4: Прогнать тесты и анализатор**

Run: `flutter test` → зелёные. `flutter analyze` → 7 info.

---

### Задача 4: Шапка групп как содержимое хрома

**Files:**
- Create: `mobile/lib/features/groups/presentation/groups_header.dart`
- Modify: `mobile/lib/features/groups/presentation/groups_screen.dart` (пока только: убрать из неё дублирующую логику шапки — сам экран трогаем в задаче 6)
- Test: `mobile/test/features/groups/presentation/groups_header_test.dart`

**Interfaces:**
- Consumes: `groupsBrowseProvider` (задача 3), `GradientHeaderSurface`/`GradientHeaderContent` (задача 2).
- Produces: `class GroupsHeader extends ConsumerStatefulWidget` с `const GroupsHeader({super.key})`.

Тесты этой задачи и задачи 5 поднимают шапку так же, как это делает оболочка в задаче 6: `MaterialApp(home: Scaffold(body: GradientHeaderSurface(child: <шапка>)))`. Сама шапка отдаёт только содержимое — подложку ей даёт оболочка.

- [ ] **Step 1: Написать падающий тест**

```dart
// Оверрайды: sharedPreferencesProvider (mock), groupsProvider → const <Group>[],
// groupsQueryProvider при необходимости.
testWidgets('шапка показывает поиск и подсказку, когда группа не выбрана', ...) {
  // 'VSTU HOME', 'Найдите свою учебную группу', find.byType(SearchBar) findsOneWidget
}

testWidgets('кнопка «Назад» появляется при выборе факультета и поднимает на уровень выше', ...) {
  // container.read(groupsBrowseProvider.notifier).selectFaculty('ФИТ'); pump
  // find.byTooltip('Назад') → tap → faculty == null
}

testWidgets('поле поиска показывает уже сохранённый запрос', ...) {
  // groupsQueryProvider.notifier.update('А-3') до pumpWidget
  // → tester.widget<SearchBar>(...).controller!.text == 'А-3'
}

testWidgets('ввод обновляет провайдер, «Очистить» его сбрасывает', ...) {
  // enterText → pump(AppConfig.searchDebounce + 20мс) → query == 'А-3'
  // tap по tooltip 'Очистить' → query == '' и поле пустое
}
```

- [ ] **Step 2: Убедиться, что тест падает**

Run: `flutter test test/features/groups/presentation/groups_header_test.dart`
Expected: FAIL — `GroupsHeader` не определён.

- [ ] **Step 3: Реализовать `GroupsHeader`**

Перенести из `groups_screen.dart` блок `GradientHeader(...)` целиком: `leading` (кнопка «Назад» при выбранном факультете, `onPressed` → `groupsBrowseProvider.notifier.up()`), `title: 'VSTU HOME'`, `subtitle` (прежний `_subtitleFor`), `actions` (расписание моей группы, `SdoButton`, настройки) и `child: SearchBar(...)`. `TextEditingController` инициализируется `ref.read(groupsQueryProvider)`, дебаунс — `Timer(AppConfig.searchDebounce, ...)` с `update(value)`; `dispose` отменяет таймер и освобождает контроллер. `GroupsHeader.build` возвращает **только** `GradientHeaderContent(...)` — подложку даёт вызывающий (в оболочке это общий `GradientHeaderSurface`, до задачи 6 — сам экран).

- [ ] **Step 4: Убрать дублирование из `GroupsScreen`**

Удалить из `groups_screen.dart` прежний блок шапки, `_searchController`, `_debounce`, `_onSearchChanged`, `_clearSearch`, `_subtitleFor`, поля `_faculty`/`_course` и `_goBack`. **Сразу же** перевести тело экрана на `groupsBrowseProvider`: выбор факультета/курса в `_buildHierarchy` — через `ref.read(groupsBrowseProvider.notifier).selectFaculty/selectCourse`, а `PopScope` — на `browse.faculty == null || query.isNotEmpty` с `up()` в колбэке. Так состояние остаётся ровно в одном месте, и приложение работает на каждом шаге. Экран пока продолжает рисовать `Scaffold` и шапку, но уже как `GradientHeaderSurface(child: const GroupsHeader())`. Полный перенос шапки в оболочку — задача 6 (там снимаются только `Scaffold` и шапка).

- [ ] **Step 5: Прогнать тесты и анализатор**

Run: `flutter test` → зелёные. `flutter analyze` → 7 info.

---

### Задача 5: Шапка расписания как содержимое хрома

**Files:**
- Create: `mobile/lib/features/schedule/presentation/schedule_header.dart`
- Modify: `mobile/lib/features/schedule/presentation/schedule_screen.dart` (удалить `_ScheduleHeader`, использовать новый виджет)
- Modify: `mobile/lib/features/schedule/presentation/schedule_providers.dart` (общий `refreshSemesterSchedule`)
- Test: `mobile/test/features/schedule/presentation/schedule_header_test.dart`

**Interfaces:**
- Produces: `class ScheduleHeader extends ConsumerWidget` с `const ScheduleHeader({super.key, required int groupId})`; `Future<void> refreshSemesterSchedule(WidgetRef ref, int groupId)` — `ref.invalidate(semesterScheduleProvider(groupId))`, затем `await ref.read(semesterScheduleProvider(groupId).future)` с проглатыванием ошибки.

- [ ] **Step 1: Написать падающий тест**

```dart
// Оверрайды: sharedPreferencesProvider; semesterScheduleProvider(1) →
// GroupSchedule(group: GroupInfo(id: 1, name: 'А-37', facultyName: 'ФИТ', course: 2),
// semesterStart: DateTime(2025, 2, 3), weekAnchor: WeekCycleAnchor(date: DateTime(2025,2,3), number: 1))
testWidgets('шапка показывает группу и её факультет с курсом', ...) {
  // 'А-37', 'ФИТ • 2 курс', find.byTooltip('Список групп'), find.byTooltip('Обновить')
}

testWidgets('известная неделя даёт навигатор недель', ...) {
  // find.byType(WeekNavigator) findsOneWidget
}

testWidgets('«Обновить» переспрашивает расписание', ...) {
  // int fetches = 0; overrideWith((ref) { fetches++; return schedule; })
  // tap 'Обновить' → fetches == 2
}
```

- [ ] **Step 2: Убедиться, что тест падает**

Run: `flutter test test/features/schedule/presentation/schedule_header_test.dart`
Expected: FAIL — `ScheduleHeader` не определён.

- [ ] **Step 3: Реализовать**

Перенести `_ScheduleHeader` из `schedule_screen.dart` в новый файл как публичный `ScheduleHeader`, читающий провайдеры сам (`semesterScheduleProvider(groupId)`, week offset, clock) и собирающий `GradientHeaderContent` с `leading` («К списку групп», `context.go('/')`), `title` (имя группы), `subtitle` (факультет • курс, через `courseLabel`), `actions` (`SdoButton`, настройки, `onRefresh`) и `child: WeekNavigator(...)`. `refresh` вызывает `refreshSemesterSchedule(ref, groupId)`.

- [ ] **Step 4: Подключить в экране и вынести `refresh`**

`schedule_screen.dart` рисует `GradientHeaderSurface(child: ScheduleHeader(groupId: groupId))` вместо приватного класса и переиспользует `refreshSemesterSchedule` (через `unawaited`), чтобы логика обновления не раздваивалась. Убрать ставшие ненужными импорты (`gradient_header.dart`, `sdo_button.dart`, `week_navigator.dart`), которые проверяет `flutter analyze`.

- [ ] **Step 5: Прогнать тесты и анализатор**

Run: `flutter test` → зелёные. `flutter analyze` → 7 info.

---

### Задача 6: Оболочка, `ShellRoute` и содержание без хрома

**Files:**
- Create: `mobile/lib/app/app_shell.dart`
- Create: `mobile/test/support/app_harness.dart`
- Modify: `mobile/lib/app/router.dart:27-56`
- Modify: `mobile/lib/features/groups/presentation/groups_screen.dart` (стать `ConsumerWidget`, отдать содержание без `Scaffold` и шапки)
- Modify: `mobile/lib/features/schedule/presentation/schedule_screen.dart` (то же)
- Modify: `mobile/test/app/router_page_transitions_test.dart` (перейти на общий харнесс)
- Test: `mobile/test/app/app_shell_test.dart`

**Interfaces:**
- Consumes: `GroupsHeader` (задача 4), `ScheduleHeader` (задача 5), `GradientHeaderSurface` (задача 2).
- Produces: `class AppShell extends StatelessWidget` с `const AppShell({super.key, required String location, required Widget header, required Widget child})`; `Widget appShellFor(GoRouterState state, Widget child)` — выбирает шапку по маршруту; в тестах — `Future<GoRouter> pumpApp(WidgetTester tester)` из `test/support/app_harness.dart` (поднимает настоящий `VstuApp` с оверрайдами `sharedPreferencesProvider`, `groupsProvider` и `semesterScheduleProvider(1)`; без `pumpAndSettle` — в приложении тикает таймер часов).

- [ ] **Step 1: Вынести тестовый харнесс и написать падающие тесты**

Сначала `test/support/app_harness.dart`: `pumpApp(WidgetTester)` = нынешний `_pumpApp` из `router_page_transitions_test.dart` плюс оверрайд `semesterScheduleProvider(1)` (`GroupSchedule(group: GroupInfo(id: 1, name: 'А-37', facultyName: 'ФИТ', course: 2), semesterStart: DateTime(2025, 2, 3), weekAnchor: WeekCycleAnchor(date: DateTime(2025, 2, 3), number: 1))`), чтобы расписание рисовалось без сети. `router_page_transitions_test.dart` переходит на него.

```dart
// app_shell_test.dart — на настоящем VstuApp + routerProvider через pumpApp().
testWidgets('шапка стоит на месте, а содержание едет', ...) {
  // offset до: headerBefore = tester.getTopLeft(find.byType(GradientHeaderSurface))
  // unawaited(router.push('/schedule/1')); pump; pump(60мс)
  // dx содержания > 0; getTopLeft(шапки) == headerBefore
  // pump(400мс): dx == 0; шапка всё ещё там же
}

testWidgets('кнопки шапки нажимаются в корневом навигаторе', ...) {
  // final ctx = tester.element(find.byType(GroupsHeader));
  // expect(Navigator.of(ctx, rootNavigator: true), same(Navigator.of(ctx)));
}

testWidgets('экран настроек не оказывается внутри оболочки', ...) {
  // unawaited(router.push('/settings')); pump; pump(400мс)
  // expect(find.ancestor(of: find.byType(SettingsScreen), matching: find.byType(AppShell)), findsNothing);
}

testWidgets('содержимое шапки меняется кроссфейдом', ...) {
  // при push: середина перехода — обе шапки в дереве; после — только ScheduleHeader
}

testWidgets('запрос поиска переживает уход на расписание и возврат', ...) {
  // enterText в SearchBar → pump(дебаунс) → push('/schedule/1') → pump(400мс)
  // → контейнер router.pop() → pump(400мс) → поле снова показывает запрос
}
```

- [ ] **Step 2: Убедиться, что тесты падают**

Run: `flutter test test/app/app_shell_test.dart`
Expected: FAIL — `AppShell` не определён.

- [ ] **Step 3: Реализовать оболочку**

`lib/app/app_shell.dart`: `AppShell` рисует `Scaffold(body: Column(children: [GradientHeaderSurface(child: AnimatedSize(...)), Expanded(child: child)]))`, где внутри подложки — `AnimatedSwitcher` (180 мс, ключ `ValueKey<String>(location)`), обёрнутый в `AnimatedSize` (220 мс, `alignment: Alignment.topCenter`, `Curves.easeInOutCubicEmphasized`). `appShellFor(GoRouterState state, Widget child)` выбирает шапку так: `int.tryParse(state.pathParameters['groupId'] ?? '')` → `null` даёт `const GroupsHeader()`, иначе `ScheduleHeader(groupId: groupId)`; тем же значением пользуется `_materialPage` в маршруте расписания, поэтому невалидный `groupId` даёт согласованную пару «шапка групп + список групп».

- [ ] **Step 4: Завернуть маршруты в `ShellRoute`**

В `router.dart` группы и расписание переезжают под один `ShellRoute(builder: (context, state, child) => appShellFor(state, child))`, `pageBuilder` обоих маршрутов остаются явными `MaterialPage` через `_materialPage`. Настройки остаются отдельным верхнеуровневым маршрутом вне оболочки. Саму оболочку намеренно **не** переводить на `MaterialPage` (`pageBuilder` у `ShellRoute` не задавать), чтобы при пуше настроек её хром не уезжал.

- [ ] **Step 5: Отдать из экранов только содержание**

Здесь снимается только хром: `GroupsScreen` → `ConsumerWidget`, возвращает `Column(children: [OfflineBanner(...), Expanded(child: body)])` (иерархия и `PopScope` уже на провайдере — задача 4), `ScheduleScreen` — то же самое, без `Scaffold` и без `GradientHeaderSurface`.

- [ ] **Step 6: Прогнать тесты и анализатор**

Run: `flutter test` → зелёные. `flutter analyze` → 7 info. Отдельно проверить, что `router_page_transitions_test.dart` (переход настроек) остался зелёным.

---

### Задача 7: «Назад» внутри оболочки

**Files:**
- Test: `mobile/test/app/shell_back_test.dart` (новый файл)
- Modify (только если тест вскроет проблему): `mobile/lib/app/router.dart`, `mobile/lib/features/groups/presentation/groups_screen.dart`

**Interfaces:**
- Consumes: `groupsBrowseProvider` (задача 3), оболочку (задача 6).

- [ ] **Step 1: Написать тесты**

```dart
testWidgets('жест «назад» при выбранном курсе поднимает на факультет, а не закрывает приложение', ...) {
  // selectFaculty('ФИТ'); selectCourse(2); pump
  // final scope = tester.widget<PopScope<Object?>>(find.descendant(
  //   of: find.byType(GroupsScreen), matching: find.byType(PopScope<Object?>)));
  // expect(scope.canPop, isFalse);
  // await tester.binding.handlePopRoute(); pump
  // expect(browse.course, isNull); expect(browse.faculty, 'ФИТ');
  // expect(router.state.uri.path, '/');
}

testWidgets('жест «назад» на верхнем уровне списка не трогает выбор', ...) {
  // без факультета: canPop == true, handlePopRoute не меняет groupsBrowseProvider
}
```

- [ ] **Step 2: Прогнать тесты**

Run: `flutter test test/app/shell_back_test.dart`
Expected: PASS — поведение проверено зондом заранее. Если тест падает (например, выбор сбрасывается или маршрут уезжает), чинить **здесь**, не переписывая задачи 1–6: сначала разобраться, кто перехватил pop (вложенный навигатор оболочки или `PopScope` экрана), и зафиксировать причину в комментарии рядом с исправлением.

- [ ] **Step 3: Прогнать весь набор**

Run: `flutter test` → 162 + новые зелёные. `flutter analyze` → 7 info.

---

## Итоговая проверка

- `flutter test` — весь набор зелёный.
- `flutter analyze` — 7 известных info, ничего нового.
- `dart format lib test` по изменённым файлам.
- Собрать profile-APK и показать владельцу: `flutter build apk --profile`, затем установка и запуск на телефоне. Ожидаемое ощущение: шапка не двигается, содержание расписания въезжает справа поверх ушедшего влево и притухшего списка групп; в шапке кроссфейдом меняются заголовок, подзаголовок и «поиск ↔ неделя».
