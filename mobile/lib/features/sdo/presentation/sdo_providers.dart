import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sdo_api_client.dart';
import '../data/sdo_data_source.dart';
import '../data/sdo_models.dart';
import '../data/sdo_repository.dart';
import '../data/sdo_token_store.dart';

final sdoApiClientProvider = Provider<SdoApiClient>((ref) {
  final SdoApiClient client = SdoApiClient();
  ref.onDispose(client.close);
  return client;
});

final sdoTokenStoreProvider = Provider<SdoTokenStore>(
  (ref) => SecureSdoTokenStore(),
);

final sdoDataSourceProvider = Provider<SdoDataSource>(
  (ref) => MoodleSdoDataSource(ref.watch(sdoApiClientProvider)),
);

final sdoRepositoryProvider = Provider<SdoRepository>(
  (ref) => SdoRepository(
    ref.watch(sdoDataSourceProvider),
    ref.watch(sdoTokenStoreProvider),
  ),
);

/// Состояние входа в СДО: `null` — гость, иначе профиль пользователя.
class SdoAuthController extends AsyncNotifier<SdoProfile?> {
  @override
  Future<SdoProfile?> build() => ref.read(sdoRepositoryProvider).restore();

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading<SdoProfile?>();
    state = await AsyncValue.guard(
      () => ref
          .read(sdoRepositoryProvider)
          .login(username: username, password: password),
    );
    if (state.hasValue) {
      _invalidateData();
    }
  }

  Future<void> logout() async {
    await ref.read(sdoRepositoryProvider).logout();
    state = const AsyncData<SdoProfile?>(null);
    _invalidateData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<SdoProfile?>();
    state = await AsyncValue.guard(
      () => ref.read(sdoRepositoryProvider).restore(),
    );
  }

  void _invalidateData() {
    ref.invalidate(sdoCoursesProvider);
    ref.invalidate(sdoDeadlinesProvider);
  }
}

final sdoAuthProvider = AsyncNotifierProvider<SdoAuthController, SdoProfile?>(
  SdoAuthController.new,
);

final sdoCoursesProvider = FutureProvider<List<SdoCourse>>(
  (ref) => ref.watch(sdoRepositoryProvider).fetchCourses(),
);

final sdoDeadlinesProvider = FutureProvider<List<SdoDeadline>>(
  (ref) => ref.watch(sdoRepositoryProvider).fetchDeadlines(),
);

final sdoCourseContentsProvider = FutureProvider.family<List<SdoSection>, int>(
  (ref, courseId) =>
      ref.watch(sdoRepositoryProvider).fetchCourseContents(courseId),
);

final sdoCourseGradesProvider = FutureProvider.family<SdoCourseGrades, int>(
  (ref, courseId) => ref.watch(sdoRepositoryProvider).fetchCourseGrades(courseId),
);
