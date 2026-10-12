const List<String> _monthsGenitive = <String>[
  'января',
  'февраля',
  'марта',
  'апреля',
  'мая',
  'июня',
  'июля',
  'августа',
  'сентября',
  'октября',
  'ноября',
  'декабря',
];

String _hhmm(DateTime value) {
  final String hh = value.hour.toString().padLeft(2, '0');
  final String mm = value.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
}

/// Человекочитаемый дедлайн: «Сегодня, 23:59», «Завтра, 14:00»,
/// «12 октября, 09:30».
String formatDeadline(DateTime when, {DateTime? now}) {
  final DateTime today = _dateOnly(now ?? DateTime.now());
  final DateTime date = _dateOnly(when);
  final int diff = date.difference(today).inDays;
  final String time = _hhmm(when);

  return switch (diff) {
    0 => 'Сегодня, $time',
    1 => 'Завтра, $time',
    -1 => 'Вчера, $time',
    _ => '${when.day} ${_monthsGenitive[when.month - 1]}, $time',
  };
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

/// Короткая дата начала/окончания курса: «12.10.2026».
String formatShortDate(DateTime value) {
  final String dd = value.day.toString().padLeft(2, '0');
  final String mm = value.month.toString().padLeft(2, '0');
  return '$dd.$mm.${value.year}';
}
