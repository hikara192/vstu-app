int? asInt(Object? value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '');
}

Map<String, dynamic>? asMap(Object? value) =>
    value is Map ? value.cast<String, dynamic>() : null;

String? asString(Object? value) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? null : text;
}
