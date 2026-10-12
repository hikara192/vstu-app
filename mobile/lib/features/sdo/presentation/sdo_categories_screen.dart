import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../data/sdo_exception.dart';
import '../data/sdo_models.dart';
import 'sdo_course_screen.dart';
import 'sdo_courses_tab.dart';
import 'sdo_providers.dart';

/// Экран выбора специальности/категории курсов.
class SdoCategoriesScreen extends ConsumerWidget {
  const SdoCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<SdoCategory>> categories = ref.watch(
      sdoCategoriesProvider,
    );

    return categories.when(
      loading: () => const GroupsSkeleton(),
      error: (Object error, _) => ErrorView(
        message: describeSdoError(error),
        onRetry: () => ref.invalidate(sdoCategoriesProvider),
      ),
      data: (List<SdoCategory> items) {
        // Отображаем только корневые категории (parent == 0 или null)
        final List<SdoCategory> roots = items
            .where((SdoCategory c) => c.parent == null || c.parent == 0)
            .toList();
        if (roots.isEmpty) {
          return const _EmptyCategories();
        }
        return RefreshIndicator(
          onRefresh: () async => ref.refresh(sdoCategoriesProvider.future),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: roots.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) => _CategoryCard(
              category: roots[index],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => SdoCategoryCoursesScreen(category: roots[index]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});

  final SdoCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school_outlined,
                  color: scheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      category.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (category.courseCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Курсов: ${category.courseCount}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCategories extends StatelessWidget {
  const _EmptyCategories();

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
              Icons.school_outlined,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text('Специальностей нет', style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              'На сервере СДО не найдено категорий курсов.',
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

/// Экран курсов внутри выбранной категории.
class SdoCategoryCoursesScreen extends ConsumerWidget {
  const SdoCategoryCoursesScreen({super.key, required this.category});

  final SdoCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(category.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        body: SdoCoursesTab(
          onOpenCourse: (SdoCourse course) => Navigator.of(context)
              .push(
                MaterialPageRoute<void>(
                  builder: (_) => SdoCourseScreen(course: course),
                ),
              ),
        ),
      ),
    );
  }
}