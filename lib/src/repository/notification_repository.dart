import 'package:c_messaging/src/base/notification_base.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/service/notification_service_debug.dart';
import 'package:c_messaging/src/service/notification_service_fcm.dart';
import 'package:flutter/material.dart';

class NotificationRepository implements NotificationBase {
  NotificationServiceMode _notificationServiceMode;
  DebugNotificationService _debugNotificationService;
  FcmNotificationService _fcmNotificationService;

  NotificationRepository({
    @required NotificationServiceMode notificationServiceMode,
    @required DebugNotificationService debugNotificationService,
    @required FcmNotificationService fcmNotificationService,
  }) {
    _notificationServiceMode = notificationServiceMode;
    _debugNotificationService = debugNotificationService;
    _fcmNotificationService = fcmNotificationService;
  }

  @override
  Future<void> initialize() async {
    if (_notificationServiceMode == NotificationServiceMode.Debug) {
      return await _debugNotificationService.initialize();
    } else if (_notificationServiceMode ==
        NotificationServiceMode.FirebaseCloudMessaging) {
      return await _fcmNotificationService.initialize();
    } else {
      return null;
    }
  }

  @override
  Future<String> getNotificationId() async {
    if (_notificationServiceMode == NotificationServiceMode.Debug) {
      return await _debugNotificationService.getNotificationId();
    } else if (_notificationServiceMode ==
        NotificationServiceMode.FirebaseCloudMessaging) {
      return await _fcmNotificationService.getNotificationId();
    } else {
      return null;
    }
  }

  @override
  Future<NotificationResult> sendNotification(String notificationTitle,
      String notificationBody, String receiverNotificationId) async {
    if (_notificationServiceMode == NotificationServiceMode.Debug) {
      return await _debugNotificationService.sendNotification(
          notificationTitle, notificationBody, receiverNotificationId);
    } else if (_notificationServiceMode ==
        NotificationServiceMode.FirebaseCloudMessaging) {
      return await _fcmNotificationService.sendNotification(
          notificationTitle, notificationBody, receiverNotificationId);
    } else {
      return null;
    }
  }
}
