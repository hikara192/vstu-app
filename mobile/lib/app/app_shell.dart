import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/gradient_header.dart';
import '../features/groups/presentation/groups_header.dart';
import '../features/schedule/presentation/schedule_header.dart';

/// Постоянная оболочка приложения: шапка, которая не двигается при переходах.
///
/// Подложка шапки живёт здесь — вне анимируемого маршрута, — поэтому при
/// навигации между списком групп и расписанием она остаётся на месте, а едет
/// только содержание ([child]). Меняющееся содержимое шапки подменяется
/// кроссфейдом на месте: заголовок, подзаголовок и действия перетекают друг в
/// друга, высота (поиск против недели) анимируется, сама шапка не сдвигается.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.location,
    required this.header,
    required this.child,
  });

  /// Текущий адрес: по нему кроссфейд понимает, что содержимое сменилось.
  final String location;

  /// Содержимое шапки для текущего адреса.
  final Widget header;

  /// Содержание экрана — то единственное, что участвует в переходе.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          GradientHeaderSurface(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 220),
              alignment: Alignment.topCenter,
              curve: Curves.easeInOutCubicEmphasized,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                layoutBuilder: _topAligned,
                child: KeyedSubtree(
                  key: ValueKey<String>(location),
                  child: header,
                ),
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Кладёт уходящую и входящую шапки стопкой сверху.
///
/// Со стандартной раскладкой (`Stack` по центру) шапки разной высоты прыгали бы
/// по вертикали, пока одна растворяется, а вторая проявляется.
Widget _topAligned(Widget? current, List<Widget> previous) {
  return Stack(
    alignment: Alignment.topCenter,
    children: <Widget>[...previous, ?current],
  );
}

/// Выбирает оболочку с шапкой, подходящей текущему маршруту.
///
/// Группы и расписание живут под одной оболочкой, поэтому шапка обязана
/// совпадать с содержанием. `groupId` разбирается так же, как в маршруте
/// расписания: иначе невалидный адрес дал бы шапку расписания над списком групп.
Widget appShellFor(GoRouterState state, Widget child) {
  final int? groupId = int.tryParse(state.pathParameters['groupId'] ?? '');
  return AppShell(
    // `matchedLocation` у оболочки не меняется между её маршрутами, поэтому
    // кроссфейд ключуется по настоящему адресу.
    location: state.uri.path,
    header: groupId == null
        ? const GroupsHeader()
        : ScheduleHeader(groupId: groupId),
    child: child,
  );
}
