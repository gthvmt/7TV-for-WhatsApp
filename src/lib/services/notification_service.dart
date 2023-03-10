import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static const _processingChannelId = 'processingChannel';
  static const _processingChannelName = 'Processing';
  static const _processingChannelDescription = 'Shown when a sticker is being processed';
  final _service = FlutterLocalNotificationsPlugin();
  Future<bool?> initialize() =>
      _service.initialize(const InitializationSettings(android: AndroidInitializationSettings('mipmap/ic_launcher')));

  Future<void> startProcessing(String emoteId, String stickerName) async {
    await _service.show(
        emoteId.hashCode,
        'Processing sticker \'$stickerName\'...',
        null,
        const NotificationDetails(
            android: AndroidNotificationDetails(_processingChannelId, _processingChannelName,
                channelDescription: _processingChannelDescription,
                // importance: Importance.max,
                // priority: Priority.max,
                showProgress: true,
                indeterminate: true,
                ongoing: true)));
  }

  Future<void> endProcessing(String emoteId) => _service.cancel(emoteId.hashCode);

  Future<void> cancel(int id) => _service.cancel(id);
}
