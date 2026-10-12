import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../data/sdo_exception.dart' show describeSdoError;
import '../data/sdo_models.dart';
import '../sdo_screen.dart';
import 'sdo_providers.dart';

/// Вкладка «Тесты» курса.
class SdoQuizzesTab extends ConsumerWidget {
  const SdoQuizzesTab({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<SdoQuiz>> quizzes = ref.watch(
      sdoQuizzesProvider(courseId),
    );

    return quizzes.when(
      loading: () => const GroupsSkeleton(),
      error: (Object error, _) => ErrorView(
        message: describeSdoError(error),
        onRetry: () => ref.invalidate(sdoQuizzesProvider(courseId)),
      ),
      data: (List<SdoQuiz> items) {
        if (items.isEmpty) {
          return const _EmptyQuizzes();
        }
        return RefreshIndicator(
          onRefresh: () async => ref.refresh(sdoQuizzesProvider(courseId).future),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) => _QuizCard(quiz: items[index]),
          ),
        );
      },
    );
  }
}

class _QuizCard extends ConsumerWidget {
  const _QuizCard({required this.quiz});

  final SdoQuiz quiz;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool openNow = quiz.isOpenNow;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SdoQuizScreen(quiz: quiz),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: (openNow ? scheme.primary : scheme.outline)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.quiz_outlined,
                      color: openNow ? scheme.primary : scheme.outline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          quiz.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: openNow
                                    ? scheme.primaryContainer
                                    : scheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                openNow ? 'Открыт' : (quiz.isNotYetOpen ? 'Скоро' : 'Закрыт'),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: openNow
                                      ? scheme.onPrimaryContainer
                                      : scheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (quiz.timeLimit > 0) ...<Widget>[
                              const SizedBox(width: 8),
                              Icon(Icons.timer_outlined, size: 12, color: scheme.onSurfaceVariant),
                              const SizedBox(width: 2),
                              Text(
                                _formatDuration(quiz.timeLimit),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                            if (quiz.maxAttempts > 0) ...<Widget>[
                              const SizedBox(width: 8),
                              Icon(Icons.replay_outlined, size: 12, color: scheme.onSurfaceVariant),
                              const SizedBox(width: 2),
                              Text(
                                'Попыток: ${quiz.maxAttempts}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    openNow ? Icons.play_circle_outline : Icons.lock_outline,
                    color: openNow ? scheme.primary : scheme.outline,
                    size: 28,
                  ),
                ],
              ),
              if (quiz.intro.isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Text(
                  quiz.intro,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (quiz.timeOpen != null || quiz.timeClose != null) ...<Widget>[
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    if (quiz.timeOpen != null) ...<Widget>[
                      Icon(Icons.schedule, size: 12, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        'Нач: ${_formatDateTime(quiz.timeOpen!)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (quiz.timeOpen != null && quiz.timeClose != null)
                      const SizedBox(width: 12),
                    if (quiz.timeClose != null) ...<Widget>[
                      Icon(Icons.block, size: 12, color: scheme.error),
                      const SizedBox(width: 4),
                      Text(
                        'Кonec: ${_formatDateTime(quiz.timeClose!)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes мин';
    final int h = minutes ~/ 60;
    final int m = minutes % 60;
    return m == 0 ? '$h ч' : '$h ч $m мин';
  }

  String _formatDateTime(DateTime dt) {
    final String dd = dt.day.toString().padLeft(2, '0');
    final String mm = dt.month.toString().padLeft(2, '0');
    final String hh = dt.hour.toString().padLeft(2, '0');
    final String mi = dt.minute.toString().padLeft(2, '0');
    return '$dd.$mm ${hh}:$mi';
  }
}

class _EmptyQuizzes extends StatelessWidget {
  const _EmptyQuizzes();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.quiz_outlined,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text('Тестов нет', style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              'Преподаватель пока не добавил тестов в этот курс.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Экран конкретного теста: информация + запуск в WebView (автологин).
class SdoQuizScreen extends ConsumerWidget {
  const SdoQuizScreen({super.key, required this.quiz});

  final SdoQuiz quiz;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<SdoQuizAttempt>> attempts = ref.watch(
      sdoQuizAttemptsProvider(quiz.id),
    );

    return Scaffold(
      appBar: AppBar(title: Text(quiz.name)),
      body: attempts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, _) => ErrorView(
          message: describeSdoError(error),
          onRetry: () => ref.invalidate(sdoQuizAttemptsProvider(quiz.id)),
        ),
        data: (List<SdoQuizAttempt> data) => _QuizBody(
          quiz: quiz,
          attempts: data,
        ),
      ),
    );
  }
}

class _QuizBody extends ConsumerWidget {
  const _QuizBody({required this.quiz, required this.attempts});

  final SdoQuiz quiz;
  final List<SdoQuizAttempt> attempts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool openNow = quiz.isOpenNow;

    final SdoQuizAttempt? lastAttempt = attempts.isNotEmpty ? attempts.last : null;
    final bool hasActiveAttempt = lastAttempt != null && lastAttempt.isInProgress;
    final bool canStartNew = openNow &&
        (attempts.isEmpty || !hasActiveAttempt) &&
        (quiz.maxAttempts == 0 || attempts.length < quiz.maxAttempts);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        if (quiz.intro.isNotEmpty) ...<Widget>[
          Text('Описание', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(quiz.intro, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
        ],
        _InfoRow(
          icon: quiz.isNotYetOpen ? Icons.lock : (quiz.isClosed ? Icons.block : Icons.check_circle),
          label: quiz.isNotYetOpen
              ? 'Начнётся'
              : (quiz.isClosed ? 'Закончился' : 'Доступен'),
          value: _formatDateTime(quiz.timeOpen ?? quiz.timeClose ?? DateTime.now()),
          color: quiz.isNotYetOpen
              ? scheme.primary
              : (quiz.isClosed ? scheme.error : scheme.secondary),
        ),
        if (quiz.timeLimit > 0)
          _InfoRow(
            icon: Icons.timer_outlined,
            label: 'Лимит времени',
            value: _formatDuration(quiz.timeLimit),
          ),
        if (quiz.maxAttempts > 0)
          _InfoRow(
            icon: Icons.replay_outlined,
            label: 'Макс. попыток',
            value: '${attempts.length} / ${quiz.maxAttempts}',
          ),
        if (attempts.isNotEmpty) ...<Widget>[
          const SizedBox(height: 16),
          Text('Ваши попытки', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          for (final SdoQuizAttempt attempt in attempts)
            _AttemptTile(attempt: attempt, quiz: quiz),
        ],
        const SizedBox(height: 24),
        if (canStartNew)
          FilledButton.icon(
            onPressed: () => _startQuiz(context, ref),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Начать тест'),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          )
        else if (hasActiveAttempt)
          OutlinedButton.icon(
            onPressed: () => _resumeQuiz(context, ref, lastAttempt!),
            icon: const Icon(Icons.refresh),
            label: const Text('Продолжить'),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          )
        else if (!openNow)
          OutlinedButton.icon(
            onPressed: null,
            icon: Icon(quiz.isNotYetOpen ? Icons.lock : Icons.block),
            label: Text(quiz.isNotYetOpen ? 'Тест ещё не начался' : 'Тест завершён'),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          )
        else
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.check),
            label: const Text('Попытки исчерпаны'),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          ),
      ],
    );
  }

  Future<void> _startQuiz(BuildContext context, WidgetRef ref) async {
    await _openQuiz(context, ref);
  }

  Future<void> _resumeQuiz(
    BuildContext context,
    WidgetRef ref,
    SdoQuizAttempt attempt,
  ) async {
    await _openQuiz(context, ref, attemptId: attempt.id);
  }

  Future<void> _openQuiz(
    BuildContext context,
    WidgetRef ref, {
    int? attemptId,
  }) async {
    final String? url = await ref.read(sdoRepositoryProvider).autologinUrl();
    final String targetUrl = url ?? 'https://sdo.vstu.by/mod/quiz/view.php?id=${quiz.courseModuleId}';
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SdoScreen(initialUrl: targetUrl),
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes мин';
    final int h = minutes ~/ 60;
    final int m = minutes % 60;
    return m == 0 ? '$h ч' : '$h ч $m мин';
  }

  String _formatDateTime(DateTime dt) {
    final String dd = dt.day.toString().padLeft(2, '0');
    final String mm = dt.month.toString().padLeft(2, '0');
    final String hh = dt.hour.toString().padLeft(2, '0');
    final String mi = dt.minute.toString().padLeft(2, '0');
    return '$dd.$mm ${hh}:$mi';
  }
}

class _AttemptTile extends StatelessWidget {
  const _AttemptTile({required this.attempt, required this.quiz});

  final SdoQuizAttempt attempt;
  final SdoQuiz quiz;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool finished = attempt.isFinished;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          finished ? Icons.check_circle : Icons.hourglass_empty,
          color: finished ? scheme.secondary : scheme.primary,
        ),
        title: Text('Попытка ${attempt.attempt}'),
        subtitle: attempt.timeStart != null
            ? Text('Начата: ${_formatDateTime(attempt.timeStart!)}')
            : null,
        trailing: finished && attempt.grade != null
            ? Text(
                attempt.grade!.toStringAsFixed(1),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              )
            : Text(
                finished ? 'Завершено' : 'В процессе',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: finished ? scheme.secondary : scheme.primary,
                ),
              ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final String dd = dt.day.toString().padLeft(2, '0');
    final String mm = dt.month.toString().padLeft(2, '0');
    final String hh = dt.hour.toString().padLeft(2, '0');
    final String mi = dt.minute.toString().padLeft(2, '0');
    return '$dd.$mm ${hh}:$mi';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = color ?? theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 16, color: accent),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}