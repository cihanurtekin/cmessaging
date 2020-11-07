import 'package:c_messaging/src/base/custom_user_database_base.dart';
import 'package:c_messaging/src/model/custom_user.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreCustomUserDatabaseService implements CustomUserDatabaseBase {
  FirebaseSettings _firebaseSettings;
  FirebaseFirestore _firestore;

  FirestoreCustomUserDatabaseService({
    @required FirebaseSettings firebaseSettings,
  }) {
    _firebaseSettings = firebaseSettings;
    _firestore = FirebaseFirestore.instance;
    _firestore.settings = Settings(
      persistenceEnabled:
          _firebaseSettings.firestorePersistenceEnabledCustomUser,
    );
  }

  @override
  Future<CustomUser> getUser(dynamic userId) async {
    if (userId is String) {
      DocumentSnapshot snapshot = await _firestore
          .collection(_firebaseSettings.usersCollectionName)
          .doc(userId)
          .get();

      Map<String, dynamic> snapshotData = snapshot.data();

      if (snapshotData != null) {
        String profilePhotoUrl =
            snapshotData[_firebaseSettings.userProfilePhotoUrlKey] ??
                _firebaseSettings.defaultProfilePhotoUrl;
        String username = snapshotData[_firebaseSettings.usernameKey] ??
            _firebaseSettings.defaultUsername;
        String firebaseMessagingId =
            snapshotData[_firebaseSettings.userNotificationIdKey] ??
                _firebaseSettings.defaultNotificationId;

        CustomUser user = CustomUser(
          userId: userId,
          username: username,
          profilePhotoUrl: profilePhotoUrl,
          notificationId: firebaseMessagingId,
        );
        return user;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
