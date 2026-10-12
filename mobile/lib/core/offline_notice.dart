import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfflineNotice extends Notifier<bool> {
  @override
  bool build() => false;

  void show() {
    if (!state) state = true;
  }

  void hide() {
    if (state) state = false;
  }
}

final isOfflineNoticeVisibleProvider = NotifierProvider<OfflineNotice, bool>(
  OfflineNotice.new,
);
