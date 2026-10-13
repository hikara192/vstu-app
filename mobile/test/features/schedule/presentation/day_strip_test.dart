import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/schedule/domain/schedule_builder.dart';
import 'package:vstu_app/features/schedule/presentation/day_strip.dart';

const Key _pillKey = dayStripPillKey;

final DateTime _monday = DateTime(2025, 9, 1);

List<DayView> _weekDays() => List<DayView>.generate(
  7,
  (int i) => DayView(
    date: _monday.add(Duration(days: i)),
    week: WeekInfo(
      number: 1,
      startsOn: _monday,
      endsOn: _monday.add(const Duration(days: 6)),
    ),
    slots: const <LessonSlot>[],
  ),
);

/// Тестовый хост: держит выбранный день, как это делает WeekContent.
class _DayStripHost extends StatefulWidget {
  const _DayStripHost({required this.days, required this.now});

  final List<DayView> days;
  final DateTime now;

  @override
  State<_DayStripHost> createState() => _DayStripHostState();
}

class _DayStripHostState extends State<_DayStripHost> {
  int _active = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DayStrip(
          days: widget.days,
          now: widget.now,
          activeIndex: _active,
          onSelect: (int index) => setState(() => _active = index),
        ),
      ),
    );
  }
}

void main() {
  group('DayStrip', () {
    double pillLeft(WidgetTester tester) =>
        tester.getTopLeft(find.byKey(_pillKey)).dx;

    double chipLeft(WidgetTester tester, int index) {
      final days = _weekDays();
      return tester
          .getTopLeft(
            find.ancestor(
              of: find.text('${days[index].date.day}'),
              matching: find.byType(DayChip),
            ),
          )
          .dx;
    }

    testWidgets('таблетка лежит под активным днём и едет при смене дня', (
      tester,
    ) async {
      final days = _weekDays();
      await tester.pumpWidget(_DayStripHost(days: days, now: _monday));
      await tester.pumpAndSettle();

      expect(pillLeft(tester), closeTo(chipLeft(tester, 0), 0.5));

      await tester.tap(find.text('${days[4].date.day}'));
      await tester.pumpAndSettle();

      expect(pillLeft(tester), closeTo(chipLeft(tester, 4), 0.5));
    });
  });
}
