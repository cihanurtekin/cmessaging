import 'package:c_messaging/src/base/notification_base.dart';
import 'package:c_messaging/src/tools/locator.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/service/base/notification_service.dart';
import 'package:c_messaging/src/service/firebase/fcm_notification_service.dart';
import 'package:c_messaging/src/settings/service_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';
import 'package:flutter/material.dart';

class NotificationRepository implements NotificationBase {
  NotificationService _service = locator<FcmNotificationService>();

  @override
  Future<void> initialize(BuildContext context, SettingsBase settings) async {
    if (settings is ServiceSettings) {
      if (settings.userDatabaseServiceMode ==
          UserDatabaseServiceMode.Firestore) {
        _service = locator<FcmNotificationService>();
      } else {
        //_service = locator<DebugNotificationService>();
      }
    }
  }

  @override
  Future<String?> getNotificationId() async {
    return await _service.getNotificationId();
  }

  @override
  Future<NotificationResult> sendNotification({
    required String title,
    required String body,
    required String receiverNotificationId,
    String? currentUserId,
  }) async {
    return await _service.sendNotification(
      title: title,
      body: body,
      receiverNotificationId: receiverNotificationId,
      currentUserId: currentUserId,
    );
  }
}
