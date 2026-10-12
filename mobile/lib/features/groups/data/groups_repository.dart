import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config.dart';
import 'group.dart';
import 'groups_data_source.dart';

typedef GroupsFetchListener = void Function({required bool servedFromCache});

class GroupsRepository {
  GroupsRepository(this._source, [this._prefs, this._onResult]);

  final GroupsDataSource _source;
  final SharedPreferences? _prefs;
  final GroupsFetchListener? _onResult;

  Future<List<Group>> fetchGroups({String query = ''}) async {
    final trimmed = query.trim();
    try {
      final groups = await _source.fetchGroups(query: trimmed);

      if (trimmed.isEmpty && _prefs != null && groups.isNotEmpty) {
        try {
          final encoded = jsonEncode([for (final g in groups) g.toJson()]);
          await _prefs.setString(AppConfig.groupsCacheKey, encoded);
        } catch (_) {}
      }

      _onResult?.call(servedFromCache: false);
      return groups;
    } catch (_) {
      if (_prefs != null) {
        final cached = _prefs.getString(AppConfig.groupsCacheKey);
        if (cached != null) {
          try {
            final decoded = jsonDecode(cached);
            if (decoded is List) {
              final allGroups = [
                for (final item in decoded)
                  if (item is Map<String, dynamic>) Group.fromJson(item),
              ];

              _onResult?.call(servedFromCache: true);
              return searchGroups(allGroups, trimmed);
            }
          } catch (_) {}
        }
      }
      rethrow;
    }
  }

  Future<bool> clearCache() async {
    final prefs = _prefs;
    if (prefs == null) return false;
    final removed = prefs.containsKey(AppConfig.groupsCacheKey);
    await prefs.remove(AppConfig.groupsCacheKey);
    return removed;
  }
}
