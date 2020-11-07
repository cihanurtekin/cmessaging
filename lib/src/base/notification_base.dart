import 'package:c_messaging/src/main/public_enums.dart';

abstract class NotificationBase {

  Future<String> getNotificationId();

  Future<void> initialize();

  Future<NotificationResult> sendNotification(String notificationTitle,
      String notificationBody, String receiverNotificationId);
}
