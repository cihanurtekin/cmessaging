import 'package:firebase_messaging/firebase_messaging.dart';

class FcmNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getNotificationId() async {
    return await _firebaseMessaging.getToken();
  }
}
