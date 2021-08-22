import 'package:c_messaging/src/settings/settings_base.dart';
import 'package:flutter/material.dart';

class FcmSettings implements SettingsBase {
  final String projectId;
  final String privateKeyId;
  final String privateKey;
  final String clientEmail;
  final String clientId;

  //final String serverKey;
  late String notificationUrl;
  final void Function(BuildContext context, Map<String, dynamic> message)?
      onFcmMessage;
  static void Function(Map<String, dynamic> message)?
      onFcmBackgroundMessageHandler;
  final void Function(BuildContext context, Map<String, dynamic> message)?
      onFcmMessageOpened;
  final String notificationType;
  final bool showForegroundNotifications;

  FcmSettings({
    required this.projectId,
    required this.privateKeyId,
    required this.privateKey,
    required this.clientEmail,
    required this.clientId,
    //required this.serverKey,
    this.onFcmMessage,
    Function(Map<String, dynamic> message)? onFcmBackgroundMessage,
    this.onFcmMessageOpened,
    this.notificationType = 'message',
    this.showForegroundNotifications = true,
  }) {
    notificationUrl =
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
    onFcmBackgroundMessageHandler = onFcmBackgroundMessage;
  }
}
