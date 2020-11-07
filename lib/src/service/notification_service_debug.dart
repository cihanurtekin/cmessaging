import 'package:c_messaging/src/base/notification_base.dart';
import 'package:c_messaging/src/main/public_enums.dart';

class DebugNotificationService implements NotificationBase {
  @override
  Future<void> initialize() {
    return null;
  }

  @override
  Future<String> getNotificationId() {
    return null;
  }

  @override
  Future<NotificationResult> sendNotification(String notificationTitle,
      String notificationBody, String receiverNotificationId) {
    return null;
  }
}