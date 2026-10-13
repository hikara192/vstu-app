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

/// Что открыто в списке групп: факультет и курс внутри него.
///
/// Держится в провайдере, а не в состоянии экрана: шапка стала частью оболочки,
/// содержимое экрана пересоздаётся при переходах, а место в списке должно
/// пережить возврат из расписания.
class GroupsBrowseState {
  const GroupsBrowseState({this.faculty, this.course});

  final String? faculty;

  final int? course;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupsBrowseState &&
          other.faculty == faculty &&
          other.course == course;

  @override
  int get hashCode => Object.hash(faculty, course);
}

/// Уровни обзора групп: сверху факультеты, внутри факультета курсы.
class GroupsBrowse extends Notifier<GroupsBrowseState> {
  @override
  GroupsBrowseState build() => const GroupsBrowseState();

  /// Открывает факультет. Курс сбрасывается: на новом факультете его ещё нет.
  void selectFaculty(String name) {
    if (state.faculty != name || state.course != null) {
      state = GroupsBrowseState(faculty: name);
    }
  }

  /// Открывает курс внутри выбранного факультета.
  void selectCourse(int course) {
    if (state.course != course) {
      state = GroupsBrowseState(faculty: state.faculty, course: course);
    }
  }

  /// Шаг назад по иерархии: сначала снимает курс, затем факультет.
  void up() {
    if (state.course != null) {
      state = GroupsBrowseState(faculty: state.faculty);
    } else if (state.faculty != null) {
      state = const GroupsBrowseState();
    }
  }

  /// Возвращает список групп к самому верхнему уровню.
  void reset() {
    if (state.faculty != null || state.course != null) {
      state = const GroupsBrowseState();
    }
  }
}

final groupsBrowseProvider = NotifierProvider<GroupsBrowse, GroupsBrowseState>(
  GroupsBrowse.new,
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
