import 'package:flutter/material.dart';

/// Лёгкий press-эффект: вложенный виджет плавно уменьшается при нажатии
/// и возвращается в исходный масштаб при отпускании или отмене нажатия.
///
/// Работает через сырые события указателя ([Listener]), поэтому не
/// конкурирует за жесты с вложенными виджетами — например, с ripple у
/// InkWell внутри карточки.
class PressScale extends StatefulWidget {
  const PressScale({
    super.key,
    required this.child,
    this.scale = 0.97,
    this.duration = const Duration(milliseconds: 120),
  });

  final Widget child;

  /// Масштаб при удержании.
  final double scale;

  final Duration duration;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1, end: _pressed ? widget.scale : 1),
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
        builder: (BuildContext context, double value, Widget? child) =>
            Transform.scale(scale: value, child: child),
      ),
    );
  }
}
