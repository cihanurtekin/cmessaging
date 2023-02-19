import 'package:c_messaging/src/model/user.dart';
import 'package:c_messaging/src/service/base/user_database_service.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserDatabaseService implements UserDatabaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseSettings? _firebaseSettings;

  @override
  void initialize(SettingsBase settings) {
    if (settings is FirebaseSettings) {
      _firebaseSettings = settings;
      _firestore.settings = Settings(
        persistenceEnabled: settings.firestorePersistenceEnabledUser,
      );
    }
  }

  @override
  Future<User?> getUser(dynamic userId) async {
    if (userId is String && _firebaseSettings != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(_firebaseSettings!.usersCollectionName)
          .doc(userId)
          .get();

      Map<String, dynamic>? snapshotData = snapshot.data();

      if (snapshotData != null) {
        String profilePhotoUrl =
            snapshotData[_firebaseSettings!.userProfilePhotoUrlKey] ??
                _firebaseSettings!.defaultProfilePhotoUrl;
        String username = snapshotData[_firebaseSettings!.usernameKey] ??
            _firebaseSettings!.defaultUsername;
        String firebaseMessagingId =
            snapshotData[_firebaseSettings!.userNotificationIdKey] ??
                _firebaseSettings!.defaultNotificationId;

        User user = User(
          userId: userId,
          username: username,
          profilePhotoUrl: profilePhotoUrl,
          notificationId: firebaseMessagingId,
        );
        return user;
      }
    }
    return null;
  }
}
