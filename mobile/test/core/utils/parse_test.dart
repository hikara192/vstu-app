import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/core/utils/parse.dart';

void main() {
  group('asInt', () {
    test('returns ints as-is and parses numeric strings', () {
      expect(asInt(5), 5);
      expect(asInt('7'), 7);
    });

    test('returns null for non-numeric or missing input', () {
      expect(asInt('абв'), isNull);
      expect(asInt(null), isNull);
    });
  });

  group('asMap', () {
    test('casts a Map to Map<String, dynamic>', () {
      expect(asMap(<String, Object?>{'a': 1}), <String, dynamic>{'a': 1});
    });

    test('returns null for non-map input', () {
      expect(asMap(<Object?>[1]), isNull);
      expect(asMap(null), isNull);
    });
  });

  group('asString', () {
    test('trims whitespace and returns the text', () {
      expect(asString('  hi  '), 'hi');
      expect(asString(42), '42');
    });

    test('returns null for empty or missing input', () {
      expect(asString(''), isNull);
      expect(asString('   '), isNull);
      expect(asString(null), isNull);
    });
  });
}