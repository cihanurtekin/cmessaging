import 'package:c_messaging/c_messaging.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

abstract class NotificationBase {
  Future<void> initialize(SettingsBase settings);

  Future<String?> getNotificationId();

  Future<NotificationResult> sendNotification(
    String notificationTitle,
    String notificationBody,
    String receiverNotificationId,
  );
}
