import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/gradient_header.dart';
import '../features/groups/presentation/groups_header.dart';
import '../features/schedule/presentation/schedule_header.dart';
import 'app_colors.dart';

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
          Expanded(
            child: Stack(children: <Widget>[child, const _HeaderShadow()]),
          ),
        ],
      ),
    );
  }
}

/// Тень шапки, нарисованная поверх содержания.
///
/// Подложка шапки стоит в разметке выше страниц, поэтому её собственная тень
/// уходит под них — а страницы непрозрачны, и тень пропадала бы совсем. Здесь
/// та же тень рисуется ещё раз, слоем выше содержания.
class _HeaderShadow extends StatelessWidget {
  const _HeaderShadow();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _HeaderShadowPainter(
            GradientHeaderSurface.shadowOf(AppColors.of(context)),
          ),
        ),
      ),
    );
  }
}

/// Рисует тень шапки над верхом области содержания.
///
/// Источник тени — прямоугольник во всю ширину области, нижняя кромка которого
/// совпадает с низом шапки (он же верх области содержания): тень ложится ровно
/// под шапку и едет вместе с её меняющейся высотой. Вверх источник уходит
/// заведомо выше, чем достаёт размытие, поэтому его верхняя кромка в кадр не
/// попадает; вниз тень обрезается по области содержания.
///
/// Тень рисуется сама, а не через `BoxDecoration`: штатные тени платформа в
/// тестах гасит — рисует жёсткими и обрезает по источнику, — и по картинке
/// нельзя было бы убедиться, что тень вообще есть. Геометрия и краска взяты у
/// платформы: тот же [BoxShadow.toPaint] по той же геометрии.
class _HeaderShadowPainter extends CustomPainter {
  const _HeaderShadowPainter(this.shadows);

  final List<BoxShadow> shadows;

  /// Насколько высоко уходит источник тени.
  ///
  /// Много больше радиуса размытия (20), чтобы верхняя кромка источника не
  /// подсвечивала тень у нижней.
  static const double _sourceHeight = 120;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    final Rect source = Rect.fromLTRB(0, -_sourceHeight, size.width, 0);
    for (final BoxShadow shadow in shadows) {
      final Rect bounds = source
          .shift(shadow.offset)
          .inflate(shadow.spreadRadius);
      canvas.drawRRect(
        GradientHeaderSurface.bottomRadius.toRRect(bounds),
        shadow.toPaint(),
      );
    }
  }

  @override
  bool shouldRepaint(_HeaderShadowPainter oldDelegate) =>
      !listEquals(oldDelegate.shadows, shadows);
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
