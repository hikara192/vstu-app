import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/app/shared_axis_page_transitions.dart';
import 'package:vstu_app/app/theme.dart';

const Color _seed = Color(0xFF1B5E9C);

Finder _firstAncestor<T>(String text) =>
    find.ancestor(of: find.text(text), matching: find.byType(T)).first;

void main() {
  test('длительность перехода — 300 мс (M3 medium1)', () {
    const builder = SharedAxisPageTransitionsBuilder();

    expect(builder.transitionDuration, const Duration(milliseconds: 300));
  });

  testWidgets('входящий экран въезжает справа и проявляется', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(_seed),
        home: const Scaffold(body: Text('home')),
      ),
    );

    tester
        .state<NavigatorState>(find.byType(Navigator))
        .push<void>(
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                const Scaffold(body: Text('second')),
          ),
        );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    final Offset translation = tester
        .widget<FractionalTranslation>(
          _firstAncestor<FractionalTranslation>('second'),
        )
        .translation;
    expect(
      translation.dx,
      greaterThan(0),
      reason: 'входящий экран должен быть смещён от центра вправо',
    );
    expect(
      translation.dx,
      lessThan(SharedAxisPageTransitionsBuilder.kSlideFraction),
    );

    final double opacity = tester
        .widget<Opacity>(_firstAncestor<Opacity>('second'))
        .opacity;
    expect(
      opacity,
      greaterThan(0),
      reason: 'входящий экран должен быть уже частично виден',
    );
    expect(opacity, lessThan(1));
  });
}
