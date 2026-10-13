import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;

/// Оборачивает контент и управляет анимацией смены темы «circular reveal»
/// (в стиле Android 12).
///
/// Как это работает:
/// 1. [ThemeRevealAreaState.revealFrom] снимает текущий кадр (экран со старой
///    темой) в один `ui.Image`.
/// 2. Вызывающий код мгновенно применяет новую тему (`commit`) — благодаря
///    `themeAnimationDuration: Duration.zero` дерево перестраивается один раз.
/// 3. Поверх нового экрана рисуется снимок старого, обрезанный по окружности,
///    которая растёт из точки нажатия: внутри круга — новая тема, снаружи —
///    старая.
///
/// Производительность (важно — раньше смена темы лагала секунду):
/// * снимок снимается **один раз** и хранится как закэшированная движком
///   текстура (`ui.Image`, без кодирования в PNG), поэтому последние кадры
///   раскрытия дёшевы;
/// * каждый кадр перерисовывается **только оверлей** (ClipPath + RawImage),
///   само дерево приложения между кадрами анимации не перестраивается;
/// * разрешение снимка ограничено сверху (см. [ThemeRevealArea.capturePixelRatio]),
///   чтобы сам момент снятия кадра не стоил дорого.
class ThemeRevealArea extends StatefulWidget {
  const ThemeRevealArea({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 380),
    this.capturePixelRatio,
    this.captureOverride,
  });

  /// Контент, который будет «раскрываться» (обычно весь экран).
  final Widget child;

  /// Длительность раскрытия круга.
  final Duration duration;

  /// Разрешение снимка в кратности к логическим пикселям. Чем меньше — тем
  /// дешевле снятие кадра (меньше памяти и времени). По умолчанию берётся
  /// `devicePixelRatio`, но не больше 2.0: снимок на время анимации чуть мягче,
  /// зато не тормозит первый кадр.
  final double? capturePixelRatio;

  /// Тестовый хук: заменяет снятие кадра (см. тесты ThemeRevealArea).
  @visibleForTesting
  final Future<ui.Image?> Function()? captureOverride;

  @override
  ThemeRevealAreaState createState() => ThemeRevealAreaState();
}

class ThemeRevealAreaState extends State<ThemeRevealArea>
    with SingleTickerProviderStateMixin {
  /// Ключ границы, из которой снимается кадр «до смены темы».
  final GlobalKey _boundaryKey = GlobalKey();

  AnimationController? _controller;
  ui.Image? _snapshot;
  Offset _center = Offset.zero;

  /// Идёт ли снятие кадра (оверлей ещё не выложен). Нужен отдельно от
  /// [_revealing], потому что между входом в [revealFrom] и `setState(_snapshot=…)`
  /// есть асинхронный участок (`await toImage`), на котором _revealing ещё false
  /// и повторный тап проскочил бы мимо защиты.
  bool _capturing = false;

  bool get _revealing => _snapshot != null;

  /// Точка нажатия (в локальных координатах оверлея), из которой раскрывается
  /// круг. Доступна для проверок в тестах.
  @visibleForTesting
  Offset get revealCenter => _center;

  /// Текущее продвижение анимации (0..1). Доступно для проверок в тестах:
  /// между применением темы и стартом анимации оверлей обязан быть на 0,
  /// иначе на кадр высвечивается новая тема (вспышка).
  @visibleForTesting
  double get revealProgress => _controller?.value ?? 0.0;

  double get _effectiveCapturePixelRatio {
    final double dpr = MediaQuery.devicePixelRatioOf(context);
    return (widget.capturePixelRatio ?? dpr).clamp(1.0, 2.0).toDouble();
  }

  /// Раскрыть экран круговой маской из точки [globalPoint].
  ///
  /// [commit] применяет новую тему (меняет состояние хранилища темы). Он
  /// вызывается только после того, как кадр снят, и до начала анимации.
  Future<void> revealFrom(
    Offset globalPoint,
    Future<void> Function() commit,
  ) async {
    // Повторные вызовы игнорируем: и когда анимация уже идёт (_revealing),
    // и пока ещё снимается кадр (_capturing) — иначе повторный тап в окне
    // снятия кадра дал бы два применения темы (и второе — «без оверлея»).
    if (_revealing || _capturing) return;
    _capturing = true;

    // Точка и разрешение снимка вычисляются синхронно — до первого await,
    // чтобы не держать BuildContext через асинхронный разрыв.
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) {
      _capturing = false;
      await commit();
      return;
    }
    final Offset center = renderObject.globalToLocal(globalPoint);
    final double pixelRatio = _effectiveCapturePixelRatio;

    ui.Image? image;
    if (widget.captureOverride != null) {
      try {
        image = await widget.captureOverride!();
      } catch (_) {
        image = null;
      }
    } else {
      final RenderObject? boundaryRender = _boundaryKey.currentContext
          ?.findRenderObject();
      if (boundaryRender is RenderRepaintBoundary) {
        try {
          image = await boundaryRender.toImage(pixelRatio: pixelRatio);
        } catch (_) {
          image = null;
        }
      }
    }

    if (image == null) {
      // Кадр снять не удалось (или это тестовый fallback) — просто меняем тему.
      _capturing = false;
      await commit();
      return;
    }
    if (!mounted) {
      _capturing = false;
      image.dispose();
      return;
    }

    _controller ??= AnimationController(vsync: this, duration: widget.duration);
    // КРИТИЧНО: контроллер после прошлой анимации стоит на value 1.0. Если не
    // сбросить его до setState, то в паузе между setState и forward() (пока
    // commit ещё на await) оверлей рисуется как progress==1 — круг раскрыл
    // весь экран, снимок старой темы срезается целиком и на кадр «высвечивается»
    // вся новая тема (вспышка), и только потом стартует анимация с нуля.
    _controller!.reset();

    setState(() {
      _snapshot = image;
      _center = center;
    });
    // С этого момента защиту от повторных вызовов держит _revealing.
    _capturing = false;

    await commit();
    if (!mounted) {
      _clearSnapshot();
      return;
    }

    unawaited(_controller!.forward().whenComplete(_finish));
  }

  void _finish() {
    if (!mounted) return;
    setState(_clearSnapshot);
  }

  void _clearSnapshot() {
    _snapshot?.dispose();
    _snapshot = null;
  }

  @override
  void dispose() {
    _clearSnapshot();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        RepaintBoundary(key: _boundaryKey, child: widget.child),
        if (_revealing && _controller != null)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller!,
                // Снимок не пересоздаётся между кадрами — текстура одна.
                child: RawImage(image: _snapshot, fit: BoxFit.fill),
                builder: (BuildContext context, Widget? child) {
                  final double t = Curves.easeInOutCubic.transform(
                    _controller!.value,
                  );
                  return ClipPath(
                    clipper: _OutsideCircleClipper(
                      center: _center,
                      progress: t,
                    ),
                    child: child,
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

/// Клип «всё, кроме растущей окружности»: снаружи круга остаётся снимок старой
/// темы, внутри раскрывается новая.
///
/// [progress] — 0..1, продвижение раскрытия. Радиус круга вычисляется здесь же
/// из реального размера клипа, чтобы не читать размеры во время build.
class _OutsideCircleClipper extends CustomClipper<Path> {
  const _OutsideCircleClipper({required this.center, required this.progress});

  final Offset center;
  final double progress;

  @override
  Path getClip(Size size) {
    double maxDistance = 0;
    for (final Offset corner in <Offset>[
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ]) {
      maxDistance = math.max(maxDistance, (corner - center).distance);
    }
    // Небольшой запас, чтобы после касания дальнего угла не осталось кромки.
    final double radius = ui.lerpDouble(0, maxDistance + 8, progress)!;

    final Path full = Path()..addRect(Offset.zero & size);
    final Path hole = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    return Path.combine(PathOperation.difference, full, hole);
  }

  @override
  bool shouldReclip(_OutsideCircleClipper oldClipper) =>
      oldClipper.center != center || oldClipper.progress != progress;
}
