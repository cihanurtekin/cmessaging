import 'package:c_messaging/src/repository/custom_user_database_repository.dart';
import 'package:c_messaging/src/repository/messages_database_repository.dart';
import 'package:c_messaging/src/repository/notification_repository.dart';
import 'package:c_messaging/src/service/custom_user_database_service_debug.dart';
import 'package:c_messaging/src/service/custom_user_database_service_firestore.dart';
import 'package:c_messaging/src/service/messages_database_service_debug.dart';
import 'package:c_messaging/src/service/messages_database_service_firestore.dart';
import 'package:c_messaging/src/service/notification_service_debug.dart';
import 'package:c_messaging/src/service/notification_service_fcm.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/service_settings.dart';
import 'package:flutter/material.dart';

class Repositories {
  MessagesDatabaseRepository _messagesDatabaseRepository;
  CustomUserDatabaseRepository _customUserDatabaseRepository;
  NotificationRepository _notificationRepository;

  MessagesDatabaseRepository get messagesDatabaseRepository =>
      _messagesDatabaseRepository;

  CustomUserDatabaseRepository get customUserDatabaseRepository =>
      _customUserDatabaseRepository;

  NotificationRepository get notificationRepository => _notificationRepository;

  FirebaseSettings _firebaseSettings;
  ServiceSettings _serviceSettings;

  Repositories({
    @required FirebaseSettings firebaseSettings,
    @required ServiceSettings serviceSettings,
  }) {
    _firebaseSettings = firebaseSettings;
    _serviceSettings = serviceSettings;
  }

  createAll(Function onMessageReceived) {
    _createMessagesDatabaseRepository();
    _createCustomUserDatabaseRepository();
    _createNotificationRepository(onMessageReceived);
  }

  _createMessagesDatabaseRepository() {
    DebugMessagesDatabaseService debugMessagesDatabaseService =
        DebugMessagesDatabaseService();
    FirestoreMessagesDatabaseService firestoreMessagesDatabaseService =
        FirestoreMessagesDatabaseService(
      firebaseSettings: _firebaseSettings,
    );
    _messagesDatabaseRepository = MessagesDatabaseRepository(
      databaseServiceMode: _serviceSettings.messagesDatabaseServiceMode,
      debugMessagesDatabaseService: debugMessagesDatabaseService,
      firestoreMessagesDatabaseService: firestoreMessagesDatabaseService,
    );
  }

  _createCustomUserDatabaseRepository() {
    DebugCustomUserDatabaseService debugCustomUserDatabaseService =
        DebugCustomUserDatabaseService();
    FirestoreCustomUserDatabaseService firestoreCustomUserDatabaseService =
        FirestoreCustomUserDatabaseService(
      firebaseSettings: _firebaseSettings,
    );
    _customUserDatabaseRepository = CustomUserDatabaseRepository(
      databaseServiceMode: _serviceSettings.userDatabaseServiceMode,
      debugCustomUserDatabaseService: debugCustomUserDatabaseService,
      firestoreCustomUserDatabaseService: firestoreCustomUserDatabaseService,
    );
  }

  _createNotificationRepository(Function onMessageReceived) {
    DebugNotificationService debugNotificationService =
        DebugNotificationService();
    FcmNotificationService fcmNotificationService = FcmNotificationService(
      firebaseSettings: _firebaseSettings,
      onMessageReceived: onMessageReceived,
    );
    _notificationRepository = NotificationRepository(
      notificationServiceMode: _serviceSettings.notificationServiceMode,
      debugNotificationService: debugNotificationService,
      fcmNotificationService: fcmNotificationService,
    );
  }
}
