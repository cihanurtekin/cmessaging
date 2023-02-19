import 'package:c_messaging/src/repository/storage_repository.dart';
import 'package:c_messaging/src/service/debug/debug_storage_service.dart';
import 'package:c_messaging/src/service/firebase/firebase_storage_service.dart';
import 'package:c_messaging/src/tools/locator.dart';
import 'package:c_messaging/src/repository/message_database_repository.dart';
import 'package:c_messaging/src/repository/notification_repository.dart';
import 'package:c_messaging/src/repository/user_database_repository.dart';
import 'package:c_messaging/src/service/debug/debug_message_database_service.dart';
import 'package:c_messaging/src/service/debug/debug_notification_service.dart';
import 'package:c_messaging/src/service/debug/debug_user_database_service.dart';
import 'package:c_messaging/src/service/firebase/firestore_message_database_service.dart';
import 'package:c_messaging/src/service/firebase/firestore_user_database_service.dart';
import 'package:c_messaging/src/service/firebase/fcm_notification_service.dart';
import 'package:c_messaging/src/settings/debug_settings.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/service_settings.dart';
import 'package:flutter/material.dart';

class Repositories {
  MessageDatabaseRepository? _messageDatabaseRepository =
      locator<MessageDatabaseRepository>();

  MessageDatabaseRepository? get messageDatabaseRepository =>
      _messageDatabaseRepository;

  UserDatabaseRepository? _userDatabaseRepository =
      locator<UserDatabaseRepository>();

  UserDatabaseRepository? get userDatabaseRepository => _userDatabaseRepository;

  NotificationRepository? _notificationRepository =
      locator<NotificationRepository>();

  NotificationRepository? get notificationRepository => _notificationRepository;

  StorageRepository? _storageRepository = locator<StorageRepository>();

  StorageRepository? get storageRepository => _storageRepository;

  DebugSettings _debugSettings;
  FirebaseSettings _firebaseSettings;
  ServiceSettings _serviceSettings;

  Repositories({
    required DebugSettings debugSettings,
    required FirebaseSettings firebaseSettings,
    required ServiceSettings serviceSettings,
  })  : _debugSettings = debugSettings,
        _firebaseSettings = firebaseSettings,
        _serviceSettings = serviceSettings;

  createAll(BuildContext context) {
    _createMessageDatabaseRepository();
    _createCustomUserDatabaseRepository();
    _createNotificationRepository(context);
    _createStorageRepository(context);
  }

  _createMessageDatabaseRepository() {
    DebugMessageDatabaseService debugMessageDatabaseService =
        locator<DebugMessageDatabaseService>();
    FirestoreMessageDatabaseService firestoreMessagesDatabaseService =
        locator<FirestoreMessageDatabaseService>();

    debugMessageDatabaseService.initialize(_debugSettings);
    firestoreMessagesDatabaseService.initialize(_firebaseSettings);

    //_messageDatabaseRepository = locator<MessageDatabaseRepository>();
    _messageDatabaseRepository?.initialize(_serviceSettings);
  }

  _createCustomUserDatabaseRepository() {
    DebugUserDatabaseService debugCustomUserDatabaseService =
        locator<DebugUserDatabaseService>();
    FirestoreUserDatabaseService firestoreCustomUserDatabaseService =
        locator<FirestoreUserDatabaseService>();

    debugCustomUserDatabaseService.initialize(_debugSettings);
    firestoreCustomUserDatabaseService.initialize(_firebaseSettings);

    //_userDatabaseRepository = locator<UserDatabaseRepository>();
    _userDatabaseRepository?.initialize(_serviceSettings);
  }

  _createNotificationRepository(BuildContext context) async {
    DebugNotificationService debugNotificationService =
        locator<DebugNotificationService>();
    FcmNotificationService fcmNotificationService =
        locator<FcmNotificationService>();

    await debugNotificationService.initialize(context, _debugSettings);
    await fcmNotificationService.initialize(context, _firebaseSettings);

    //_notificationRepository = locator<NotificationRepository>();
    _notificationRepository?.initialize(context, _serviceSettings);
  }

  _createStorageRepository(BuildContext context) async {
    DebugStorageService debugStorageService = locator<DebugStorageService>();
    FirebaseStorageService firebaseStorageService =
        locator<FirebaseStorageService>();

    debugStorageService.initialize(_debugSettings);
    firebaseStorageService.initialize(_firebaseSettings);

    //_storageRepository = locator<StorageRepository>();
    _storageRepository?.initialize(_serviceSettings);
  }
}
