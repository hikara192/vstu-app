String roomLabel({required String location, int? frame}) {
  final place = location.trim();

  final hasFrame = frame != null && frame > 0;
  return <String>[
    if (hasFrame) '$frame корп.',
    if (place.isNotEmpty) _placeLabel(place),
  ].join(', ');
}

String _placeLabel(String place) =>
    _leadingDigit.hasMatch(place) ? 'ауд. $place' : place;

final RegExp _leadingDigit = RegExp('^[0-9]');
