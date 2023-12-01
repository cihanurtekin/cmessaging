import 'package:c_messaging/src/repository/channel_database_repository.dart';
import 'package:c_messaging/src/repository/storage_repository.dart';
import 'package:c_messaging/src/service/firebase/firebase_storage_service.dart';
import 'package:c_messaging/src/service/firebase/firestore_channel_database_service.dart';
import 'package:c_messaging/src/tools/locator.dart';
import 'package:c_messaging/src/repository/message_database_repository.dart';
import 'package:c_messaging/src/repository/notification_repository.dart';
import 'package:c_messaging/src/repository/user_database_repository.dart';
import 'package:c_messaging/src/service/firebase/firestore_message_database_service.dart';
import 'package:c_messaging/src/service/firebase/firestore_user_database_service.dart';
import 'package:c_messaging/src/service/firebase/fcm_notification_service.dart';
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

  ChannelDatabaseRepository? _channelDatabaseRepository =
      locator<ChannelDatabaseRepository>();

  ChannelDatabaseRepository? get channelDatabaseRepository =>
      _channelDatabaseRepository;

  NotificationRepository? _notificationRepository =
      locator<NotificationRepository>();

  NotificationRepository? get notificationRepository => _notificationRepository;

  StorageRepository? _storageRepository = locator<StorageRepository>();

  StorageRepository? get storageRepository => _storageRepository;

  final FirebaseSettings _firebaseSettings;
  final ServiceSettings _serviceSettings;

  Repositories({
    required FirebaseSettings firebaseSettings,
    required ServiceSettings serviceSettings,
  })  : _firebaseSettings = firebaseSettings,
        _serviceSettings = serviceSettings;

  void createAll(BuildContext context) {
    _createMessageDatabaseRepository();
    _createCustomUserDatabaseRepository();
    _createChannelDatabaseRepository();
    _createNotificationRepository(context);
    _createStorageRepository(context);
  }

  void _createMessageDatabaseRepository() {
    FirestoreMessageDatabaseService firestoreMessagesDatabaseService =
        locator<FirestoreMessageDatabaseService>();

    firestoreMessagesDatabaseService.initialize(_firebaseSettings);

    //_messageDatabaseRepository = locator<MessageDatabaseRepository>();
    _messageDatabaseRepository?.initialize(_serviceSettings);
  }

  void _createCustomUserDatabaseRepository() {
    FirestoreUserDatabaseService firestoreCustomUserDatabaseService =
        locator<FirestoreUserDatabaseService>();

    firestoreCustomUserDatabaseService.initialize(_firebaseSettings);

    //_userDatabaseRepository = locator<UserDatabaseRepository>();
    _userDatabaseRepository?.initialize(_serviceSettings);
  }

  void _createChannelDatabaseRepository() {
    FirestoreChannelDatabaseService firestoreChannelDatabaseService =
        locator<FirestoreChannelDatabaseService>();

    firestoreChannelDatabaseService.initialize(_firebaseSettings);

    _channelDatabaseRepository?.initialize(_serviceSettings);
  }

  void _createNotificationRepository(BuildContext context) async {
    FcmNotificationService fcmNotificationService =
        locator<FcmNotificationService>();

    await fcmNotificationService.initialize(context, _firebaseSettings);

    //_notificationRepository = locator<NotificationRepository>();
    _notificationRepository?.initialize(context, _serviceSettings);
  }

  void _createStorageRepository(BuildContext context) async {
    FirebaseStorageService firebaseStorageService =
        locator<FirebaseStorageService>();

    firebaseStorageService.initialize(_firebaseSettings);

    //_storageRepository = locator<StorageRepository>();
    _storageRepository?.initialize(_serviceSettings);
  }
}
