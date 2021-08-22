import 'package:c_messaging/src/helper/locator.dart';
import 'package:c_messaging/src/repository/custom_user_database_repository.dart';
import 'package:c_messaging/src/repository/messages_database_repository.dart';
import 'package:c_messaging/src/repository/notification_repository.dart';
import 'package:c_messaging/src/service/custom_user_database_service_debug.dart';
import 'package:c_messaging/src/service/custom_user_database_service_firestore.dart';
import 'package:c_messaging/src/service/messages_database_service_debug.dart';
import 'package:c_messaging/src/service/messages_database_service_firestore.dart';
import 'package:c_messaging/src/service/notification_service_debug.dart';
import 'package:c_messaging/src/service/notification_service_fcm.dart';
import 'package:c_messaging/src/settings/debug_settings.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/service_settings.dart';
import 'package:flutter/material.dart';

class Repositories {
  late MessagesDatabaseRepository _messagesDatabaseRepository;
  late CustomUserDatabaseRepository _customUserDatabaseRepository;
  late NotificationRepository _notificationRepository;

  MessagesDatabaseRepository get messagesDatabaseRepository =>
      _messagesDatabaseRepository;

  CustomUserDatabaseRepository get customUserDatabaseRepository =>
      _customUserDatabaseRepository;

  NotificationRepository get notificationRepository => _notificationRepository;

  late DebugSettings _debugSettings;
  late FirebaseSettings _firebaseSettings;
  late ServiceSettings _serviceSettings;

  Repositories({
    required DebugSettings debugSettings,
    required FirebaseSettings firebaseSettings,
    required ServiceSettings serviceSettings,
  }) {
    _debugSettings = debugSettings;
    _firebaseSettings = firebaseSettings;
    _serviceSettings = serviceSettings;
  }

  createAll(BuildContext context) {
    _createMessagesDatabaseRepository();
    _createCustomUserDatabaseRepository();
    _createNotificationRepository(context);
  }

  _createMessagesDatabaseRepository() {
    DebugMessagesDatabaseService debugMessagesDatabaseService =
        locator<DebugMessagesDatabaseService>();
    FirestoreMessagesDatabaseService firestoreMessagesDatabaseService =
        locator<FirestoreMessagesDatabaseService>();

    debugMessagesDatabaseService.initialize(_debugSettings);
    firestoreMessagesDatabaseService.initialize(_firebaseSettings);

    _messagesDatabaseRepository = locator<MessagesDatabaseRepository>();
    _messagesDatabaseRepository.initialize(_serviceSettings);
  }

  _createCustomUserDatabaseRepository() {
    DebugCustomUserDatabaseService debugCustomUserDatabaseService =
        locator<DebugCustomUserDatabaseService>();
    FirestoreCustomUserDatabaseService firestoreCustomUserDatabaseService =
        locator<FirestoreCustomUserDatabaseService>();

    debugCustomUserDatabaseService.initialize(_debugSettings);
    firestoreCustomUserDatabaseService.initialize(_firebaseSettings);

    _customUserDatabaseRepository = locator<CustomUserDatabaseRepository>();
    _customUserDatabaseRepository.initialize(_serviceSettings);
  }

  _createNotificationRepository(BuildContext context) async {
    DebugNotificationService debugNotificationService =
        locator<DebugNotificationService>();
    FcmNotificationService fcmNotificationService =
        locator<FcmNotificationService>();

    await debugNotificationService.initialize(context, _debugSettings);
    await fcmNotificationService.initialize(context, _firebaseSettings);

    _notificationRepository = locator<NotificationRepository>();
    _notificationRepository.initialize(context, _serviceSettings);
  }
}
