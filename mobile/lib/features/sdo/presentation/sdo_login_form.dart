import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sdo_exception.dart';
import 'sdo_providers.dart';

/// Форма входа в СДО ВГТУ. Логин и пароль — те же, что на `sdo.vstu.by`.
/// Пароль нигде не сохраняется: приложение обменивает его на токен
/// веб-сервиса и хранит только токен.
class SdoLoginForm extends ConsumerStatefulWidget {
  const SdoLoginForm({super.key});

  @override
  ConsumerState<SdoLoginForm> createState() => _SdoLoginFormState();
}

class _SdoLoginFormState extends ConsumerState<SdoLoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(sdoAuthProvider.notifier)
        .login(username: _username.text.trim(), password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<Object?> auth = ref.watch(sdoAuthProvider);
    final bool loading = auth.isLoading;
    final String? error = auth.hasError ? describeSdoError(auth.error) : null;
    final ThemeData theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: <Widget>[
        Icon(
          Icons.school_outlined,
          size: 56,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 12),
        Text(
          'Вход в СДО ВГТУ',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Используйте логин и пароль от sdo.vstu.by',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _username,
                enabled: !loading,
                autofillHints: const <String>[AutofillHints.username],
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Логин',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) =>
                    (value == null || value.trim().isEmpty)
                    ? 'Введите логин'
                    : null,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _password,
                enabled: !loading,
                obscureText: _obscure,
                autofillHints: const <String>[AutofillHints.password],
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: _obscure ? 'Показать' : 'Скрыть',
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                validator: (String? value) => (value == null || value.isEmpty)
                    ? 'Введите пароль'
                    : null,
                onFieldSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
        if (error != null) ...<Widget>[
          const SizedBox(height: 16),
          _ErrorBanner(message: error),
        ],
        const SizedBox(height: 22),
        FilledButton.icon(
          onPressed: loading ? null : _submit,
          icon: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.login_rounded),
          label: Text(loading ? 'Вход…' : 'Войти'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Пароль не сохраняется на устройстве. Используя вход, вы '
          'соглашаетесь с правилами СДО ВГТУ.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.error_outline, color: scheme.onErrorContainer, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: scheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}
