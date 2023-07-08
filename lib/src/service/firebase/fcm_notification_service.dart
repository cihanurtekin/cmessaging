import 'dart:convert';

import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/c_notification.dart';
import 'package:c_messaging/src/service/base/notification_service.dart';
import 'package:c_messaging/src/settings/fcm_settings.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';

Future<void> _backgroundMessageHandler(RemoteMessage remoteMessage) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  RemoteNotification? remoteNotification = remoteMessage.notification;
  if (remoteNotification != null) {}

  //TODO: Find a way to handle background message
  //_firebaseSettings.onBackgroundMessage?.call(message);
}

class FcmNotificationService implements NotificationService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late FirebaseSettings _firebaseSettings;
  bool _showForegroundNotifications = true;

  @override
  Future<void> initialize(
      material.BuildContext context, SettingsBase settings) async {
    if (settings is FirebaseSettings) {
      _firebaseSettings = settings;
      FcmSettings? fcmSettings = _firebaseSettings.fcmSettings;
      if (fcmSettings != null) {
        _showForegroundNotifications = fcmSettings.showForegroundNotifications;

        RemoteMessage? initialMessage =
            await _firebaseMessaging.getInitialMessage();

        if (initialMessage != null) {
          CNotification? notification = _getNotification(initialMessage);
          if (notification != null) {
            if (notification.type == fcmSettings.notificationType) {
              await fcmSettings.onMessageOpenedAppTerminated
                  ?.call(context, notification);
            }
          }
        }
      }

      NotificationSettings notificationSettings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true,
      );

      if (_showForegroundNotifications) {
        await _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );
      }

      if (notificationSettings.authorizationStatus ==
              AuthorizationStatus.authorized ||
          notificationSettings.authorizationStatus ==
              AuthorizationStatus.provisional) {
        FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
          if (fcmSettings != null) {
            CNotification? notification = _getNotification(remoteMessage);
            if (notification != null) {
              fcmSettings.onForegroundMessage?.call(context, notification);
            }
          }
        });
        FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
        FirebaseMessaging.onMessageOpenedApp.listen((
          RemoteMessage remoteMessage,
        ) {
          if (fcmSettings != null) {
            CNotification? notification = _getNotification(remoteMessage);
            if (notification != null) {
              fcmSettings.onMessageOpenedAppBackground
                  ?.call(context, notification);
            }
          }
        });
      }
      getNotificationId();
    }
  }

  CNotification? _getNotification(RemoteMessage remoteMessage) {
    RemoteNotification? remoteNotification = remoteMessage.notification;
    if (remoteNotification != null) {
      return CNotification(
        id: remoteMessage.hashCode,
        title: remoteNotification.title,
        body: remoteNotification.body,
        type: remoteMessage.data[CNotification.typeKey],
        contactUserId: remoteMessage.data[CNotification.contactUserIdKey],
      );
    }
    return null;
  }

  @override
  Future<String?> getNotificationId() async {
    return await _firebaseMessaging.getToken();
  }

  @override
  Future<NotificationResult> sendNotification({
    required String title,
    required String body,
    required String receiverNotificationId,
    String? currentUserId,
  }) async {
    NotificationResult result = NotificationResult.Error;
    FcmSettings? fcmSettings = _firebaseSettings.fcmSettings;
    if (fcmSettings != null) {
      AuthClient client = await _getAuthClient(fcmSettings);
      Map<String, String> headers =
          await _getHeaders(client.credentials.accessToken);
      Uri notificationUrl = Uri.parse(fcmSettings.notificationUrl);

      String notification = _getNotificationObject(
        notificationTitle: title,
        notificationBody: body,
        firebaseMessagingId: receiverNotificationId,
        notificationType: fcmSettings.notificationType,
        notificationChannelId: fcmSettings.notificationChannelId,
        currentUserId: currentUserId,
      );

      debugPrint(notification);

      await client
          .post(notificationUrl, body: notification, headers: headers)
          .then((response) {
        debugPrint(
          "FcmNotificationService / sendNotification / Success Response : "
          "${response.body}",
        );
        result = NotificationResult.Success;
      }).catchError((e) {
        result = NotificationResult.Error;
      });
    }
    return result;
  }

  Future<AuthClient> _getAuthClient(FcmSettings fcmSettings) async {
    Map<String, String> credentialsJson = {
      'type': 'service_account',
      'project_id': fcmSettings.projectId,
      'private_key_id': fcmSettings.privateKeyId,
      'private_key': fcmSettings.privateKey,
      'client_email': fcmSettings.clientEmail,
      'client_id': fcmSettings.clientId,
    };
    ServiceAccountCredentials accountCredentials =
        ServiceAccountCredentials.fromJson(credentialsJson);
    List<String> scopes = ['https://www.googleapis.com/auth/cloud-platform'];
    return await clientViaServiceAccount(accountCredentials, scopes);
  }

  Future<Map<String, String>> _getHeaders(AccessToken accessToken) async {
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
  }

  String _getNotificationObject({
    required String notificationTitle,
    required String notificationBody,
    required String firebaseMessagingId,
    required String notificationType,
    required String notificationChannelId,
    String? currentUserId,
  }) {
    Map<String, Map<String, dynamic>> notificationMap = {
      'message': <String, dynamic>{
        'notification': <String, String>{
          CNotification.titleKey: notificationTitle,
          CNotification.bodyKey: notificationBody,
        },
        'data': <String, String>{
          CNotification.typeKey: notificationType,
          CNotification.contactUserIdKey: currentUserId ?? ''
        },
        'android': <String, dynamic>{
          'notification': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'channel_id': notificationChannelId,
          }
        },
        'token': firebaseMessagingId,
      }
    };
    if (_showForegroundNotifications) {
      notificationMap['message']?['android']?['priority'] = 'high';
    }
    return jsonEncode(notificationMap);
  }
}
