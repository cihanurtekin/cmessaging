import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/main/custom_firebase_settings.dart';
import 'package:example/model/user.dart';
import 'package:flutter/material.dart';

enum UserBaseResult { Success, Error }

class FirestoreUserDatabaseService {
  final bool firestorePersistenceEnabled =
      CustomFirebaseSettings.FIRESTORE_PERSISTENCE_ENABLED_USERS;

  FirestoreUserDatabaseService() {
    _firestore = FirebaseFirestore.instance;
    _firestore.settings =
        Settings(persistenceEnabled: firestorePersistenceEnabled);
  }

  late FirebaseFirestore _firestore;

  Future<User?> getUser(dynamic userId) async {
    if (userId is String) {
      DocumentSnapshot<Map<String, dynamic>?> snapshot =
          await _firestore.collection("users").doc(userId).get();

      Map<String, dynamic>? snapshotData = snapshot.data();

      if (snapshotData != null) {
        String profilePhotoUrl = snapshotData[User.profilePhotoUrlKey] ??
            CustomFirebaseSettings.DEFAULT_PROFILE_PHOTO_URL;
        String username = snapshotData[User.usernameKey] ??
            CustomFirebaseSettings.DEFAULT_USERNAME;
        String email = snapshotData[User.emailKey] ?? '';
        String firebaseMessagingId = snapshotData[User.notificationIdKey] ?? '';

        User user = User(
          userId,
          email,
          profilePhotoUrl: profilePhotoUrl,
          username: username,
          notificationId: firebaseMessagingId,
        );
        return user;
      }
    }
    return null;
  }

  Future<User?> getCurrentDatabaseUser() async {
    // Repository uses getUser to get current database user. Leave this method returns null.
    return Future.value();
  }

  Future<User?> updateCurrentDatabaseUser() {
    // Repository uses getUser to update current database user. Leave this method returns null.
    return Future.value();
  }

  Future<void> addUser(User user) async {
    await FirebaseFirestore.instance
        .collection(CustomFirebaseSettings.USERS_COLLECTION_NAME)
        .doc(user.userId)
        .set(user.toMap());
  }

  Future<UserBaseResult> updateUser(
      userId, Map<String, dynamic> newValues) async {
    UserBaseResult result = UserBaseResult.Error;
    if (userId is String) {
      await _firestore
          .collection(CustomFirebaseSettings.USERS_COLLECTION_NAME)
          .doc(userId)
          .update(newValues)
          .then((_) {
        result = UserBaseResult.Success;
      }).catchError((e) {
        result = UserBaseResult.Error;
        debugPrint(
          "FirestoreMessagesDatabaseService / sendMessage : ${e.toString()}",
        );
      });

      return result;
    } else {
      return UserBaseResult.Error;
    }
  }
}
