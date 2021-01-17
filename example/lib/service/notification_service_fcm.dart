import 'package:firebase_messaging/firebase_messaging.dart';

class FcmNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String> getNotificationId() async {
    String token = await _firebaseMessaging.getToken();
    print(token);
    return token;
  }
}
