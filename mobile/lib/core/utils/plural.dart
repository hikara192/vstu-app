String plural(int count, String one, String few, String many) {
  final mod100 = count % 100;
  if (mod100 >= 11 && mod100 <= 14) {
    return many;
  }
  return switch (count % 10) {
    1 => one,
    2 || 3 || 4 => few,
    _ => many,
  };
}

String lessonsLabel(int count) {
  if (count <= 0) {
    return 'занятий нет';
  }
  return '$count ${plural(count, 'пара', 'пары', 'пар')}';
}

String groupsLabel(int count) {
  if (count <= 0) {
    return 'ничего не найдено';
  }
  return '$count ${plural(count, 'группа', 'группы', 'групп')}';
}

String courseLabel(int course) => '$course курс';

String remainingLabel(Duration left) {
  if (left.inSeconds < 60) {
    return 'пара заканчивается';
  }
  return 'осталось ${durationLabel(left)}';
}

String durationLabel(Duration length) {
  final minutes = (length.inSeconds / 60).ceil();
  final hours = minutes ~/ 60;
  final rest = minutes % 60;

  if (hours == 0) {
    return _minutesLabel(minutes);
  }
  final hoursLabel = '$hours ${plural(hours, 'час', 'часа', 'часов')}';
  if (rest == 0) {
    return hoursLabel;
  }
  return '$hoursLabel ${_minutesLabel(rest)}';
}

String _minutesLabel(int minutes) =>
    '$minutes ${plural(minutes, 'минута', 'минуты', 'минут')}';
