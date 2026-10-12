import 'sdo_data_source.dart';
import 'sdo_exception.dart';
import 'sdo_models.dart';
import 'sdo_token_store.dart';

/// Объединяет источник данных СДО и хранилище токена: сам достаёт токен,
/// сам сбрасывает его при протухании и держит профиль пользователя.
class SdoRepository {
  SdoRepository(this._source, this._store);

  final SdoDataSource _source;
  final SdoTokenStore _store;

  /// Профиль из хранилища, если вход уже выполнялся.
  Future<SdoProfile?> restore() async {
    final String? token = await _store.readToken();
    if (token == null || token.isEmpty) return null;
    return _store.readProfile();
  }

  Future<SdoProfile> login({
    required String username,
    required String password,
  }) {
    return _guard(() async {
      final String token = await _source.requestToken(
        username: username,
        password: password,
      );
      final SdoProfile profile = await _source.fetchProfile(token);
      await _store.writeToken(token);
      await _store.writeProfile(profile);
      return profile;
    });
  }

  Future<void> logout() => _store.clear();

  Future<List<SdoCourse>> fetchCourses() {
    return _guard(() async {
      final String token = await _requireToken();
      final SdoProfile profile = await _profile(token);
      return _source.fetchCourses(token, userId: profile.userId);
    });
  }

  Future<List<SdoCategory>> fetchCategories() {
    return _guard(() async {
      final String token = await _requireToken();
      return _source.fetchCategories(token);
    });
  }

  Future<List<SdoDeadline>> fetchDeadlines() {
    return _guard(() async {
      final String token = await _requireToken();
      final SdoProfile profile = await _profile(token);
      final List<SdoCourse> courses = await _source.fetchCourses(
        token,
        userId: profile.userId,
      );
      final Map<int, String> names = <int, String>{
        for (final SdoCourse course in courses) course.id: course.title,
      };
      return _source.fetchDeadlines(token, courseNames: names);
    });
  }

  Future<List<SdoSection>> fetchCourseContents(int courseId) {
    return _guard(() async {
      final String token = await _requireToken();
      return _source.fetchCourseContents(token, courseId: courseId);
    });
  }

  Future<List<SdoAssignment>> fetchAssignments(int courseId) {
    return _guard(() async {
      final String token = await _requireToken();
      final SdoProfile profile = await _profile(token);
      return _source.fetchAssignments(
        token,
        courseId: courseId,
        userId: profile.userId,
      );
    });
  }

  Future<SdoSubmission> fetchSubmission(int assignmentId) {
    return _guard(() async {
      final String token = await _requireToken();
      return _source.fetchSubmission(token, assignmentId: assignmentId);
    });
  }

  Future<List<SdoQuiz>> fetchQuizzes(int courseId) {
    return _guard(() async {
      final String token = await _requireToken();
      return _source.fetchQuizzes(token, courseId: courseId);
    });
  }

  Future<List<SdoQuizAttempt>> fetchQuizAttempts(int quizId) {
    return _guard(() async {
      final String token = await _requireToken();
      final SdoProfile profile = await _profile(token);
      return _source.fetchQuizAttempts(
        token,
        quizId: quizId,
        userId: profile.userId,
      );
    });
  }

  Future<List<int>> downloadFile(String url) {
    return _guard(() async {
      final String token = await _requireToken();
      return _source.downloadFile(url, token: token);
    });
  }

  Future<void> saveSubmission({
    required int assignmentId,
    required String? onlineText,
    required String? fileName,
    required List<int>? fileBytes,
  }) {
    return _guard(() async {
      final String token = await _requireToken();
      final SdoProfile profile = await _profile(token);
      return _source.saveSubmission(
        token,
        assignmentId: assignmentId,
        userId: profile.userId,
        onlineText: onlineText,
        fileName: fileName,
        fileBytes: fileBytes,
      );
    });
  }

  Future<String?> autologinUrl() {
    return _guard(() async {
      final String token = await _requireToken();
      final SdoProfile profile = await _profile(token);
      return _source.autologinUrl(token, userId: profile.userId);
    });
  }

  Future<String> _requireToken() async {
    final String? token = await _store.readToken();
    if (token == null || token.isEmpty) {
      throw const SdoAuthException('Нужно войти в СДО ВГТУ.');
    }
    return token;
  }

  Future<SdoProfile> _profile(String token) async {
    final SdoProfile? cached = await _store.readProfile();
    if (cached != null && cached.userId > 0) return cached;
    final SdoProfile profile = await _source.fetchProfile(token);
    await _store.writeProfile(profile);
    return profile;
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on SdoAuthException {
      await _store.clear();
      rethrow;
    }
  }
}