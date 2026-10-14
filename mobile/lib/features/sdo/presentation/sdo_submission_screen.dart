import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/widgets/error_view.dart';
import '../data/sdo_exception.dart';
import '../data/sdo_models.dart';
import 'sdo_providers.dart';
import '../sdo_screen.dart';

/// Экран просмотра и отправки задания.
class SdoSubmissionScreen extends ConsumerStatefulWidget {
  const SdoSubmissionScreen({
    super.key,
    required this.assignment,
    required this.courseId,
  });

  final SdoAssignment assignment;
  final int courseId;

  @override
  ConsumerState<SdoSubmissionScreen> createState() => _SdoSubmissionScreenState();
}

class _SdoSubmissionScreenState extends ConsumerState<SdoSubmissionScreen> {
  final TextEditingController _textController = TextEditingController();
  SdoFile? _pickedFile;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<SdoSubmission> submission = ref.watch(
      sdoSubmissionProvider(widget.assignment.id),
    );

    return submission.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, _) => ErrorView(
        message: describeSdoError(error),
        onRetry: () => ref.invalidate(sdoSubmissionProvider(widget.assignment.id)),
      ),
      data: (SdoSubmission data) => _buildBody(context, data),
    );
  }

  Widget _buildBody(BuildContext context, SdoSubmission data) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool isSubmitted = data.status == SdoSubmissionStatus.submitted;
    final bool readonly = isSubmitted;

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(sdoSubmissionProvider(widget.assignment.id).future),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          if (widget.assignment.description.isNotEmpty) ...<Widget>[
            Text('Описание задания', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(
              widget.assignment.description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
          ],
          if (widget.assignment.dueDate != null)
            _InfoRow(
              icon: Icons.schedule,
              label: 'Сдача до',
              value: _formatDateTime(widget.assignment.dueDate!),
              color: isSubmitted ? scheme.onSurfaceVariant : (data.isOverdue ? scheme.error : scheme.primary),
            ),
          if (widget.assignment.allowFromDate != null)
            _InfoRow(
              icon: Icons.lock_open,
              label: 'Можно сдавать с',
              value: _formatDateTime(widget.assignment.allowFromDate!),
            ),
          if (widget.assignment.cutoffDate != null)
            _InfoRow(
              icon: Icons.block,
              label: 'Последний срок',
              value: _formatDateTime(widget.assignment.cutoffDate!),
              color: scheme.error,
            ),
          if (widget.assignment.maxAttempts > 0)
            _InfoRow(
              icon: Icons.replay,
              label: 'Макс. попыток',
              value: widget.assignment.maxAttempts.toString(),
            ),
          const SizedBox(height: 16),
          if (data.files.isNotEmpty) ...<Widget>[
            Text('Ваши файлы', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            for (final SdoFile file in data.files)
              _FileTile(
                file: file,
                onOpen: () => _openFile(ref, file),
              ),
            const SizedBox(height: 16),
          ],
          if (data.onlineText.isNotEmpty) ...<Widget>[
            Text('Ваш текст', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                data.onlineText,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (!readonly) ...<Widget>[
            if (widget.assignment.requiresText) ...<Widget>[
              Text('Ваш ответ (текст)', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _textController,
                enabled: !_loading,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Напишите ответ здесь…',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (widget.assignment.requiresFile) ...<Widget>[
              Text('Прикрепить файл', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              if (_pickedFile != null)
                _FileTile(
                  file: _pickedFile!,
                  onOpen: () => _openFile(ref, _pickedFile!),
                  onRemove: () => setState(() => _pickedFile = null),
                )
              else
                OutlinedButton.icon(
                  onPressed: _loading ? null : _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Выбрать файл'),
                ),
              const SizedBox(height: 16),
            ],
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _error!,
                  style: TextStyle(color: scheme.error),
                ),
              ),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _loading || !widget.assignment.requiresText && !widget.assignment.requiresFile
                        ? null
                        : _saveDraft,
                    child: const Text('Сохранить черновик'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _loading ? null : _submit,
                    icon: _loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    label: Text(isSubmitted ? 'Отправлено' : 'Отправить на проверку'),
                  ),
                ),
              ],
            ),
          ] else ...<Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSubmitted
                    ? scheme.secondaryContainer
                    : scheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    isSubmitted ? Icons.check_circle : Icons.edit,
                    color: isSubmitted ? scheme.onSecondaryContainer : scheme.onTertiaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isSubmitted
                          ? 'Задание отправлено на проверку. Изменения невозможны.'
                          : 'Черновик сохранён. Отправьте, когда будет готово.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSubmitted
                            ? scheme.onSecondaryContainer
                            : scheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final List<PlatformFile> files = await FilePicker.pickFiles(
        type: FileType.any,
      );
      if (files.isNotEmpty) {
        final PlatformFile file = files.single;
        final Uint8List bytes = await file.readAsBytes();
        setState(() {
          _pickedFile = SdoFile(
            fileName: file.name,
            fileSize: file.lengthSync() ?? bytes.length,
            mimeType: file.extension != null ? 'application/${file.extension}' : '',
            fileBytes: bytes,
          );
        });
      }
    } catch (e) {
      setState(() => _error = 'Не удалось выбрать файл: $e');
    }
  }

  Future<void> _saveDraft() => _persist(submit: false);

  Future<void> _submit() => _persist(submit: true);

  /// Сохраняет текст и/или файл. При [submit] дополнительно отправляет
  /// работу на проверку — это отдельный шаг Moodle, без которого задание
  /// остаётся черновиком.
  Future<void> _persist({required bool submit}) async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final String? onlineText = widget.assignment.requiresText
          ? _textController.text.trim()
          : null;
      if (submit) {
        await ref
            .read(sdoRepositoryProvider)
            .submitForGrading(
              assignmentId: widget.assignment.id,
              onlineText: onlineText,
              fileName: _pickedFile?.fileName,
              fileBytes: _pickedFile?.fileBytes,
            );
      } else {
        await ref
            .read(sdoRepositoryProvider)
            .saveSubmission(
              assignmentId: widget.assignment.id,
              onlineText: onlineText,
              fileName: _pickedFile?.fileName,
              fileBytes: _pickedFile?.fileBytes,
            );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(submit ? 'Отправлено на проверку' : 'Черновик сохранён')),
        );
        ref.invalidate(sdoSubmissionProvider(widget.assignment.id));
      }
    } on SdoException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openFile(WidgetRef ref, SdoFile file) async {
    if (file.isWebLink) {
      // Ссылка — открываем в браузере/SdoScreen
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SdoScreen(initialUrl: file.fileUrl),
        ),
      );
      return;
    }

    // Локальный файл уже выбран пользователем — открываем из памяти
    if (file.fileBytes.isNotEmpty) {
      await ref.read(sdoFileOpenerProvider).open(
        fileName: file.fileName,
        bytes: file.fileBytes,
        mimeType: file.mimeType,
      );
      return;
    }

    // Файл с сервера — скачиваем
    try {
      final List<int> bytes = await ref.read(sdoRepositoryProvider).downloadFile(file.fileUrl);
      await ref.read(sdoFileOpenerProvider).open(
        fileName: file.fileName,
        bytes: bytes,
        mimeType: file.mimeType,
      );
    } on SdoException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
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

class _FileTile extends StatelessWidget {
  const _FileTile({
    required this.file,
    required this.onOpen,
    this.onRemove,
  });

  final SdoFile file;
  final VoidCallback onOpen;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          file.isImage
              ? Icons.image_outlined
              : file.isPdf
                  ? Icons.picture_as_pdf_outlined
                  : file.isWebLink
                      ? Icons.link
                      : Icons.insert_drive_file_outlined,
          color: scheme.primary,
        ),
        title: Text(
          file.fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium,
        ),
        subtitle: file.fileSize > 0
            ? Text(
                _formatSize(file.fileSize),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              tooltip: 'Открыть',
              icon: const Icon(Icons.open_in_new),
              onPressed: onOpen,
            ),
            if (onRemove != null)
              IconButton(
                tooltip: 'Удалить',
                icon: const Icon(Icons.close),
                onPressed: onRemove,
              ),
          ],
        ),
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes Б';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} КБ';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} МБ';
  }
}