import '../../../core/network/api_exception.dart';
import '../../../core/network/uni_api_client.dart';
import '../../../core/utils/parse.dart';
import 'group.dart';

abstract interface class GroupsDataSource {
  Future<List<Group>> fetchGroups({String query});
}

const List<String> uniFacultyTypes = <String>[
  'daytime',
  'correspondence',
  'mag',
  'fpk',
];

class UniGroupsDataSource implements GroupsDataSource {
  UniGroupsDataSource(this._client);

  final UniApiClient _client;

  List<Group>? _cache;
  DateTime? _cachedAt;

  @override
  Future<List<Group>> fetchGroups({String query = ''}) async {
    return searchGroups(await _allGroups(), query);
  }

  Future<List<Group>> _allGroups() async {
    final cache = _cache;
    final cachedAt = _cachedAt;
    if (cache != null &&
        cachedAt != null &&
        DateTime.now().difference(cachedAt) < const Duration(hours: 1)) {
      return cache;
    }

    final responses = await Future.wait(
      uniFacultyTypes.map((type) => _client.getJson('/schedule/group/$type')),
    );

    final decoded = <int, Group>{};
    for (final response in responses) {
      if (response is! List) continue;
      for (final Object? item in response) {
        final json = asMap(item);
        if (json == null || asInt(json['id']) == null) continue;
        final group = groupFromUni(json);

        decoded.putIfAbsent(group.id, () => group);
      }
    }

    if (decoded.isEmpty) {
      throw const ApiException(
        'API вернул пустой список групп',
        code: 'bad_response',
      );
    }

    final groups = sortGroupsNaturally(decoded.values.toList());
    _cache = groups;
    _cachedAt = DateTime.now();
    return groups;
  }
}

Group groupFromUni(Map<String, dynamic> json) {
  final spec = asMap(json['spec']);
  return Group(
    id: asInt(json['id']) ?? 0,
    name: asString(json['name']) ?? '',
    facultyName: asString(json['facultyName']),
    facultyType: asString(json['facultyType']),
    course: asInt(json['currentCourse']),
    educationLevel: asString(json['educationLevel']),
    specShort: asString(spec?['shortName']),
    specName: asString(spec?['name']),
    specCode: asString(spec?['specCode']),
  );
}

List<Group> searchGroups(List<Group> groups, String query) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return groups;

  final matches = groups.where((group) {
    final fields = <String?>[
      group.name,
      group.specShort,
      group.specName,
      group.specCode,
      group.facultyName,
    ];
    return fields.any(
      (String? field) =>
          field != null && field.toLowerCase().contains(normalized),
    );
  }).toList();

  return sortGroupsNaturally(matches);
}

List<Group> sortGroupsNaturally(List<Group> groups) =>
    [...groups]..sort((a, b) => compareGroupNames(a.name, b.name));

int compareGroupNames(String a, String b) {
  final (leftText, leftNumber) = _nameParts(a);
  final (rightText, rightNumber) = _nameParts(b);

  final byText = leftText.compareTo(rightText);
  if (byText != 0) return byText;
  if (leftNumber != null && rightNumber != null) {
    final byNumber = leftNumber.compareTo(rightNumber);
    if (byNumber != 0) return byNumber;
  }
  return _toLowerCase(a).compareTo(_toLowerCase(b));
}

final RegExp _namePattern = RegExp(r'^(\D*)(\d+)');

(String, int?) _nameParts(String name) {
  final normalized = _toLowerCase(name);
  final match = _namePattern.firstMatch(normalized);
  if (match == null) return (normalized, null);
  return (match.group(1) ?? '', int.tryParse(match.group(2) ?? ''));
}

String _toLowerCase(String value) => value.trim().toLowerCase();
