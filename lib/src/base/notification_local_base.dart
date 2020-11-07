abstract class NotificationLocalBase {
  Future<void> initialize();

  Future<int> showNotification(int notificationId, String notificationTitle,
      String notificationBody, String receiverNotificationId);
}
