import 'package:c_messaging/src/model/c_notification.dart';
import 'package:c_messaging/src/settings/settings_base.dart';
import 'package:flutter/material.dart';

class FcmSettings implements SettingsBase {
  final String projectId;
  final String privateKeyId;
  final String privateKey;
  final String clientEmail;
  final String clientId;
  final String notificationType;
  final String notificationChannelId;

  //final String serverKey;
  late String notificationUrl;
  final Future<void> Function(BuildContext context, CNotification notification)?
      onForegroundMessage;

  //final Future<void> Function(CNotification notification)? onBackgroundMessage;
  final Future<void> Function(BuildContext context, CNotification notification)?
      onMessageOpenedAppBackground;
  final Future<void> Function(BuildContext context, CNotification notification)?
      onMessageOpenedAppTerminated;
  final bool showForegroundNotifications;

  FcmSettings({
    required this.projectId,
    required this.privateKeyId,
    required this.privateKey,
    required this.clientEmail,
    required this.clientId,
    required this.notificationType,
    required this.notificationChannelId,
    //required this.serverKey,
    this.onForegroundMessage,
    //this.onBackgroundMessage,
    this.onMessageOpenedAppBackground,
    this.onMessageOpenedAppTerminated,
    this.showForegroundNotifications = true,
  }) {
    notificationUrl =
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
  }
}
