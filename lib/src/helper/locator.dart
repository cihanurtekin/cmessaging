import 'package:c_messaging/src/dialog/dialog_helper.dart';
import 'package:c_messaging/src/repository/custom_user_database_repository.dart';
import 'package:c_messaging/src/repository/messages_database_repository.dart';
import 'package:c_messaging/src/repository/notification_repository.dart';
import 'package:c_messaging/src/service/custom_user_database_service_debug.dart';
import 'package:c_messaging/src/service/custom_user_database_service_firestore.dart';
import 'package:c_messaging/src/service/messages_database_service_debug.dart';
import 'package:c_messaging/src/service/messages_database_service_firestore.dart';
import 'package:c_messaging/src/service/notification_service_debug.dart';
import 'package:c_messaging/src/service/notification_service_fcm.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

setupLocator() {

  locator.registerLazySingleton(() => DebugCustomUserDatabaseService());
  locator.registerLazySingleton(() => FirestoreCustomUserDatabaseService());
  locator.registerLazySingleton(() => CustomUserDatabaseRepository());

  //locator.registerLazySingleton(() => FirebaseStorageService());
  //locator.registerLazySingleton(() => StorageRepository());

  locator.registerLazySingleton(() => DebugMessagesDatabaseService());
  locator.registerLazySingleton(() => FirestoreMessagesDatabaseService());
  locator.registerLazySingleton(() => MessagesDatabaseRepository());

  locator.registerLazySingleton(() => DebugNotificationService());
  locator.registerLazySingleton(() => FcmNotificationService());
  locator.registerLazySingleton(() => NotificationRepository());

  locator.registerLazySingleton(() => DialogHelper());
}