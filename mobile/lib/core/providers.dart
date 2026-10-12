import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'network/uni_api_client.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider нужно переопределить в main()',
  ),
);

final uniApiClientProvider = Provider<UniApiClient>((ref) {
  final client = UniApiClient();
  ref.onDispose(client.close);
  return client;
});

class AppClock extends Notifier<DateTime> {
  Timer? _timer;

  @override
  DateTime build() {
    _timer = Timer.periodic(AppConfig.clockTick, (_) => state = DateTime.now());
    ref.onDispose(() => _timer?.cancel());
    return DateTime.now();
  }
}

final clockProvider = NotifierProvider<AppClock, DateTime>(AppClock.new);
