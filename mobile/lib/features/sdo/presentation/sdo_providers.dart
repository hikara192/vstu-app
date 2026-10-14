import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sdo_api_client.dart';
import '../data/sdo_data_source.dart';
import '../data/sdo_file_opener.dart';
import '../data/sdo_models.dart';
import '../data/sdo_repository.dart';
import '../data/sdo_token_store.dart';
import '../sdo_session_store.dart';

final sdoApiClientProvider = Provider<SdoApiClient>((ref) {
  final SdoApiClient client = SdoApiClient();
  ref.onDispose(client.close);
  return client;
});

final sdoTokenStoreProvider = Provider<SdoTokenStore>(
  (ref) => SecureSdoTokenStore(),
);

final sdoSessionStoreProvider = Provider<SdoSessionStore>(
  (ref) => SecureSdoSessionStore(),
);

final sdoDataSourceProvider = Provider<SdoDataSource>(
  (ref) => MoodleSdoDataSource(ref.watch(sdoApiClientProvider)),
);

final sdoRepositoryProvider = Provider<SdoRepository>(
  (ref) => SdoRepository(
    ref.watch(sdoDataSourceProvider),
    ref.watch(sdoTokenStoreProvider),
    sessionStore: ref.watch(sdoSessionStoreProvider),
  ),
);

final sdoFileOpenerProvider = Provider<SdoFileOpener>(
  (ref) => SystemSdoFileOpener(),
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
    ref.invalidate(sdoCategoriesProvider);
    ref.invalidate(sdoDeadlinesProvider);
  }
}

final sdoAuthProvider = AsyncNotifierProvider<SdoAuthController, SdoProfile?>(
  SdoAuthController.new,
);

final sdoCoursesProvider = FutureProvider<List<SdoCourse>>(
  (ref) => ref.watch(sdoRepositoryProvider).fetchCourses(),
);

final sdoCategoriesProvider = FutureProvider<List<SdoCategory>>(
  (ref) => ref.watch(sdoRepositoryProvider).fetchCategories(),
);

final sdoDeadlinesProvider = FutureProvider<List<SdoDeadline>>(
  (ref) => ref.watch(sdoRepositoryProvider).fetchDeadlines(),
);

final sdoCourseContentsProvider = FutureProvider.family<List<SdoSection>, int>(
  (ref, courseId) => ref.watch(sdoRepositoryProvider).fetchCourseContents(courseId),
);

final sdoAssignmentsProvider = FutureProvider.family<List<SdoAssignment>, int>(
  (ref, courseId) => ref.watch(sdoRepositoryProvider).fetchAssignments(courseId),
);

final sdoSubmissionProvider = FutureProvider.family<SdoSubmission, int>(
  (ref, assignmentId) => ref.watch(sdoRepositoryProvider).fetchSubmission(assignmentId),
);

final sdoQuizzesProvider = FutureProvider.family<List<SdoQuiz>, int>(
  (ref, courseId) => ref.watch(sdoRepositoryProvider).fetchQuizzes(courseId),
);

final sdoQuizAttemptsProvider = FutureProvider.family<List<SdoQuizAttempt>, int>(
  (ref, quizId) => ref.watch(sdoRepositoryProvider).fetchQuizAttempts(quizId),
);