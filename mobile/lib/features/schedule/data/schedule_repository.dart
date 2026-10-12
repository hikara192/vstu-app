import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config.dart';
import 'schedule_data_source.dart';
import 'schedule_models.dart';

typedef ScheduleFetchListener = void Function({required bool servedFromCache});

class ScheduleRepository {
  ScheduleRepository(this._source, [this._prefs, this._onResult]);

  final ScheduleDataSource _source;
  final SharedPreferences? _prefs;
  final ScheduleFetchListener? _onResult;

  Future<GroupSchedule> fetchSemesterSchedule(int groupId) async {
    final cacheKey = _cacheKey(groupId);
    try {
      final anchorFuture = _fetchWeekAnchor();
      final schedule = await _source.fetchSemesterSchedule(groupId);
      final anchor = await anchorFuture;
      final result = anchor == null
          ? schedule
          : schedule.copyWith(weekAnchor: anchor);

      if (_prefs != null) {
        try {
          await _prefs.setString(cacheKey, jsonEncode(result.toJson()));
        } catch (_) {}
      }

      _onResult?.call(servedFromCache: false);
      return result;
    } catch (_) {
      if (_prefs != null) {
        final cached = _prefs.getString(cacheKey);
        if (cached != null) {
          try {
            final decoded = jsonDecode(cached);
            if (decoded is Map<String, dynamic>) {
              _onResult?.call(servedFromCache: true);
              return GroupSchedule.fromJson(decoded);
            }
          } catch (_) {}
        }
      }
      rethrow;
    }
  }

  Future<bool> clearCache(int groupId) async {
    final prefs = _prefs;
    if (prefs == null) return false;
    final removed = prefs.containsKey(_cacheKey(groupId));
    await prefs.remove(_cacheKey(groupId));
    return removed;
  }

  String _cacheKey(int groupId) => '${AppConfig.scheduleCachePrefix}$groupId';

  Future<WeekCycleAnchor?> _fetchWeekAnchor() async {
    try {
      return await _source.fetchWeekAnchor();
    } catch (_) {
      return null;
    }
  }
}
