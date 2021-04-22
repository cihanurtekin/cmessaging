import 'package:c_messaging/src/base/notification_base.dart';
import 'package:c_messaging/src/helper/locator.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/service/base/notification_service.dart';
import 'package:c_messaging/src/service/notification_service_debug.dart';
import 'package:c_messaging/src/service/notification_service_fcm.dart';
import 'package:c_messaging/src/settings/service_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

class NotificationRepository implements NotificationBase {
  NotificationService _service = locator<FcmNotificationService>();

  @override
  Future<void> initialize(SettingsBase settings) async {
    if (settings is ServiceSettings) {
      if (settings.userDatabaseServiceMode ==
          UserDatabaseServiceMode.Firestore) {
        _service = locator<FcmNotificationService>();
      } else {
        _service = locator<DebugNotificationService>();
      }
    }
  }

  @override
  Future<String?> getNotificationId() async {
    return await _service.getNotificationId();
  }

  @override
  Future<NotificationResult> sendNotification(
    String notificationTitle,
    String notificationBody,
    String receiverNotificationId,
  ) async {
    return await _service.sendNotification(
      notificationTitle,
      notificationBody,
      receiverNotificationId,
    );
  }
}
