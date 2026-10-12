import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config.dart';
import '../../../core/offline_notice.dart';
import '../../../core/providers.dart';
import '../data/group.dart';
import '../data/groups_data_source.dart';
import '../data/groups_repository.dart';

final groupsRepositoryProvider = Provider<GroupsRepository>((ref) {
  return GroupsRepository(
    UniGroupsDataSource(ref.watch(uniApiClientProvider)),
    ref.watch(sharedPreferencesProvider),
    ({required bool servedFromCache}) {
      final notice = ref.read(isOfflineNoticeVisibleProvider.notifier);
      if (servedFromCache) {
        notice.show();
      } else {
        notice.hide();
      }
    },
  );
});

class GroupsQuery extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) {
    final trimmed = value.trim();
    if (trimmed != state) {
      state = trimmed;
    }
  }
}

final groupsQueryProvider = NotifierProvider<GroupsQuery, String>(
  GroupsQuery.new,
);

final groupsProvider = FutureProvider<List<Group>>(
  (ref) => ref
      .watch(groupsRepositoryProvider)
      .fetchGroups(query: ref.watch(groupsQueryProvider)),
);

class SelectedGroup extends Notifier<Group?> {
  @override
  Group? build() {
    final preferences = ref.watch(sharedPreferencesProvider);
    final id = preferences.getInt(AppConfig.selectedGroupIdKey);
    if (id == null) {
      return null;
    }
    return Group(
      id: id,
      name:
          preferences.getString(AppConfig.selectedGroupNameKey) ?? 'Группа $id',
    );
  }

  Future<void> select(Group group) async {
    state = group;
    final SharedPreferences preferences = ref.read(sharedPreferencesProvider);
    await preferences.setInt(AppConfig.selectedGroupIdKey, group.id);
    await preferences.setString(AppConfig.selectedGroupNameKey, group.name);
  }

  Future<void> clear() async {
    state = null;
    final preferences = ref.read(sharedPreferencesProvider);
    await preferences.remove(AppConfig.selectedGroupIdKey);
    await preferences.remove(AppConfig.selectedGroupNameKey);
  }
}

final selectedGroupProvider = NotifierProvider<SelectedGroup, Group?>(
  SelectedGroup.new,
);
