import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/service/base/notification_service.dart';
import 'package:c_messaging/src/settings/settings_base.dart';
import 'package:flutter/material.dart';

class DebugNotificationService implements NotificationService {
  @override
  Future<void> initialize(BuildContext context, SettingsBase settings) {
    // TODO: implement initialize
    return Future.value();
  }

  @override
  Future<String?> getNotificationId() {
    // TODO: implement getNotificationId
    return Future.value();
  }

  @override
  Future<NotificationResult> sendNotification(String notificationTitle,
      String notificationBody, String receiverNotificationId) {
    // TODO: implement sendNotification
    throw NotificationResult.Success;
  }
}
