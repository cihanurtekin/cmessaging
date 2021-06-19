import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/service/base/notification_service.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

Future<void> _backgroundMessageHandler(RemoteMessage remoteMessage) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  Map<String, dynamic> message = remoteMessage.data;

  //TODO: Find a way to handle background message
  //_firebaseSettings.onFcmBackgroundMessage?.call(message);
}

class FcmNotificationService implements NotificationService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late FirebaseSettings _firebaseSettings;

  final String notificationJsonType = 'notification_type';
  final String notificationJsonTypeMessage = 'message';

  @override
  Future<void> initialize(SettingsBase settings) async {
    if (settings is FirebaseSettings) {
      _firebaseSettings = settings;

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

      if (notificationSettings.authorizationStatus ==
              AuthorizationStatus.authorized ||
          notificationSettings.authorizationStatus ==
              AuthorizationStatus.provisional) {
        FirebaseMessaging.onMessage.listen((
          RemoteMessage remoteMessage,
        ) {
          Map<String, dynamic> message = remoteMessage.data;
          _firebaseSettings.onFcmMessage?.call(message);
        });
        FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
        FirebaseMessaging.onMessageOpenedApp.listen((
          RemoteMessage remoteMessage,
        ) {
          Map<String, dynamic> message = remoteMessage.data;
          _firebaseSettings.onFcmMessageOpened?.call(message);
        });
      }
      getNotificationId();
    }
  }

  @override
  Future<String?> getNotificationId() async {
    return await _firebaseMessaging.getToken();
  }

  @override
  Future<NotificationResult> sendNotification(
    String notificationTitle,
    String notificationBody,
    String receiverNotificationId,
  ) async {
    NotificationResult result = NotificationResult.Error;

    Map<String, String> headers = _getHeaders(receiverNotificationId);
    Uri notificationUrl = Uri.parse(_firebaseSettings.fcmNotificationUrl);

    String notification = _getNotificationObject(
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
      firebaseMessagingId: receiverNotificationId,
    );

    await http
        .post(notificationUrl, body: notification, headers: headers)
        .then((_) {})
        .catchError((e) {
      result = NotificationResult.Error;
    });

    return result;
  }

  Map<String, String> _getHeaders(String key) {
    return {'Authorization': 'key=' + key, 'Content-Type': 'application/json'};
  }

  String _getNotificationObject({
    String notificationTitle = "",
    String notificationBody = "",
    String firebaseMessagingId = "",
  }) {
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
    return notificationObject;
  }

  String _getNotificationDataObject({
    String notificationTitle = "",
    String notificationBody = "",
    String firebaseMessagingId = "",
  }) {
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
    return notificationObject;
  }
}
