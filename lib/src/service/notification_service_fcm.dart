import 'package:c_messaging/src/base/notification_base.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FcmNotificationService implements NotificationBase {
  final String notificationJsonType = 'notification_type';
  final String notificationJsonTypeMessage = 'message';

  FirebaseSettings _firebaseSettings;
  FirebaseMessaging _firebaseMessaging;

  String _fcmServerKey;
  String _fcmNotificationUrl;

  Function(int notificationId, String title, String body,
      String receiverNotificationId) _onMessageReceived;

  FcmNotificationService({
    @required FirebaseSettings firebaseSettings,
    @required Function onMessageReceived,
  }) {
    _firebaseSettings = firebaseSettings;
    _onMessageReceived = onMessageReceived;
    _fcmServerKey = _firebaseSettings.fcmServerKey;
    _fcmNotificationUrl = _firebaseSettings.fcmNotificationUrl;
    _firebaseMessaging = FirebaseMessaging.instance;
    getNotificationId();
  }

  @override
  Future initialize() {
    /*_firebaseMessaging.configure(
      onMessage: _onMessage,
      onBackgroundMessage: _onBackgroundMessage,
      onLaunch: _onLaunch,
      onResume: _onResume,
    );*/
  }

  Future _onMessage(Map<String, dynamic> message) {
    _showNotification(message);
  }

  Future _onBackgroundMessage(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      _showNotification(message);
    }
  }

  Future _onLaunch(Map<String, dynamic> message) {}

  Future _onResume(Map<String, dynamic> message) {}

  _showNotification(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      //NotificationLocalRepository notificationLocalRepository = NotificationLocalRepository.instance;
      Map<dynamic, dynamic> data = message['data'];
      int notificationId = int.parse(data['id']);
      String title = data['title'];
      String body = data['body'];
      String receiverNotificationId = "";
      _onMessageReceived(notificationId, title, body, receiverNotificationId);
      //await _notificationLocalRepository.showNotification(notificationId, title, body, receiverNotificationId);
    }
  }

  @override
  Future<String> getNotificationId() async {
    String token = await _firebaseMessaging.getToken();
    print(token);
    return token;
  }

  @override
  Future<NotificationResult> sendNotification(String notificationTitle,
      String notificationBody, String receiverNotificationId) async {
    NotificationResult result = NotificationResult.Success;

    Map<String, String> headers = _getHeaders();

    String notification = getNotificationObject(
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
      firebaseMessagingId: receiverNotificationId,
    );

    Uri fcmNotificationUri = Uri.parse(_fcmNotificationUrl);
    await http
        .post(fcmNotificationUri, body: notification, headers: headers)
        .then((_) {})
        .catchError((e) {
      result = NotificationResult.Error;
      print("FcmNotificationService / sendNotification : " + e.toString());
    });
    return result;
  }

  Map<String, String> _getHeaders() {
    return {
      'Authorization': 'key=$_fcmServerKey',
      'Content-Type': 'application/json',
    };
  }

  String getNotificationObject({
    String notificationTitle,
    String notificationBody,
    String firebaseMessagingId,
  }) {
    //print("notificationTitle : $notificationTitle\nnotificationBody : $notificationBody\nfirebaseMessagingId : $firebaseMessagingId");
    String notificationObject = '{' +
        '\"notification\":' +
        '{' +
        '\"title\":' +
        '\"' +
        notificationTitle +
        '\",' +
        '\"body\":' +
        '\"' +
        notificationBody +
        '\",' +
        '\"sound\":' +
        '\"default\"' +
        '},' +
        '\"data\":' +
        '{' +
        '\"click_action\":' +
        '\"FLUTTER_NOTIFICATION_CLICK\",' +
        '\"id\":' +
        '\"1\",' +
        '\"status\":' +
        '\"done\",' +
        '\"' +
        notificationJsonType +
        '\":' +
        '\"' +
        notificationJsonTypeMessage +
        '\"' +
        '},' +
        '\"priority\":' +
        '\"high\",' +
        '\"to\":' +
        '\"' +
        firebaseMessagingId +
        '\"' +
        '}';
    print(notificationObject);
    return notificationObject;
  }

  String getNotificationDataObject({
    String notificationTitle,
    String notificationBody,
    String firebaseMessagingId,
  }) {
    //print("notificationTitle : $notificationTitle\nnotificationBody : $notificationBody\nfirebaseMessagingId : $firebaseMessagingId");
    String notificationObject = '{' +
        '\"data\":' +
        '{' +
        '\"title\":' +
        '\"' +
        notificationTitle +
        '\",' +
        '\"body\":' +
        '\"' +
        notificationBody +
        '\",' +
        '\"click_action\":' +
        '\"FLUTTER_NOTIFICATION_CLICK\",' +
        '\"id\":' +
        '\"1\",' +
        '\"status\":' +
        '\"done\",' +
        '\"' +
        notificationJsonType +
        '\":' +
        '\"' +
        notificationJsonTypeMessage +
        '\"' +
        '},' +
        '\"priority\":' +
        '\"high\",' +
        '\"to\":' +
        '\"' +
        firebaseMessagingId +
        '\"' +
        '}';
    print(notificationObject);
    return notificationObject;
  }
}
