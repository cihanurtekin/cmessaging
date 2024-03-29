import 'package:c_messaging/src/dialog/dialog_helper.dart';
import 'package:c_messaging/src/repository/storage_repository.dart';
import 'package:c_messaging/src/repository/user_database_repository.dart';
import 'package:c_messaging/src/repository/message_database_repository.dart';
import 'package:c_messaging/src/repository/notification_repository.dart';
import 'package:c_messaging/src/service/firebase/firebase_storage_service.dart';
import 'package:c_messaging/src/service/firebase/firestore_message_database_service.dart';
import 'package:c_messaging/src/service/firebase/firestore_user_database_service.dart';
import 'package:c_messaging/src/service/firebase/fcm_notification_service.dart';
import 'package:c_messaging/src/repository/channel_database_repository.dart';
import 'package:c_messaging/src/service/firebase/firestore_channel_database_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton(() => DialogHelper());

  locator.registerLazySingleton(() => UserDatabaseRepository());
  locator.registerLazySingleton(() => FirestoreUserDatabaseService());

  locator.registerLazySingleton(() => MessageDatabaseRepository());
  locator.registerLazySingleton(() => FirestoreMessageDatabaseService());

  locator.registerLazySingleton(() => ChannelDatabaseRepository());
  locator.registerLazySingleton(() => FirestoreChannelDatabaseService());

  locator.registerLazySingleton(() => NotificationRepository());
  locator.registerLazySingleton(() => FcmNotificationService());

  locator.registerLazySingleton(() => StorageRepository());
  locator.registerLazySingleton(() => FirebaseStorageService());
}
