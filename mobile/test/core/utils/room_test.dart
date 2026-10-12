import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/core/utils/room.dart';

void main() {
  group('roomLabel', () {
    test('joins building and room when both are present', () {
      expect(
        roomLabel(location: '305', frame: 2),
        '2 корп., ауд. 305',
      );
    });

    test('keeps a named place without an "ауд." prefix', () {
      expect(roomLabel(location: 'Актовый зал', frame: null), 'Актовый зал');
    });

    test('shows the building alone when the place is empty', () {
      expect(roomLabel(location: '', frame: 3), '3 корп.');
    });

    test('returns an empty string when nothing is known', () {
      expect(roomLabel(location: '', frame: null), '');
    });

    test('ignores a non-positive frame', () {
      expect(roomLabel(location: '305', frame: 0), 'ауд. 305');
    });
  });
}