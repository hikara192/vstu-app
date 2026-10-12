DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

DateTime mondayOf(DateTime value) =>
    dateOnly(value).subtract(Duration(days: value.weekday - 1));

DateTime? parseIsoDate(Object? value) {
  if (value is! String || value.isEmpty) return null;
  final parsed = DateTime.tryParse(
    value.substring(0, value.length < 10 ? value.length : 10),
  );
  return parsed == null ? null : dateOnly(parsed);
}

DateTime moment(DateTime date, String hhmm) {
  final parts = hhmm.split(':');
  final hours = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
  final minutes = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
  return DateTime(date.year, date.month, date.day, hours, minutes);
}
