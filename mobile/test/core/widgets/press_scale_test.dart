import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/core/widgets/press_scale.dart';

void main() {
  Finder transformOf(WidgetTester tester) => find.descendant(
    of: find.byType(PressScale),
    matching: find.byType(Transform),
  );

  double maxScale(WidgetTester tester) {
    final Transform transform = tester.widget<Transform>(
      transformOf(tester).first,
    );
    // Transform.scale масштабирует оси X/Y; getMaxScaleOnAxis() вернул бы 1.0
    // из-за неизменённой оси Z — читаем масштаб по X (m00).
    return transform.transform.storage[0];
  }

  Future<void> pumpHost(WidgetTester tester) {
    return tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: PressScale(child: SizedBox(width: 120, height: 56)),
        ),
      ),
    );
  }

  group('PressScale', () {
    testWidgets('уменьшается при нажатии и возвращается при отпускании', (
      tester,
    ) async {
      await pumpHost(tester);
      expect(maxScale(tester), closeTo(1.0, 1e-6));

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(PressScale)),
      );
      // Первый кадр запускает анимацию, второй — продвигает её.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      expect(maxScale(tester), lessThan(1.0));

      await gesture.up();
      await tester.pumpAndSettle();
      expect(maxScale(tester), closeTo(1.0, 1e-6));
    });

    testWidgets('возвращается в исходный масштаб при отмене нажатия', (
      tester,
    ) async {
      await pumpHost(tester);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(PressScale)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      expect(maxScale(tester), lessThan(1.0));

      await gesture.cancel();
      await tester.pumpAndSettle();
      expect(maxScale(tester), closeTo(1.0, 1e-6));
    });
  });
}
