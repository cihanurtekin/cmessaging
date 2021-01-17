import 'package:c_messaging/c_messaging.dart';
import 'package:example/main/custom_firebase_settings.dart';

class CMessagingSettings {
  static ServiceSettings serviceSettings = ServiceSettings(
    userDatabaseServiceMode: UserDatabaseServiceMode.Firestore,
    messagesDatabaseServiceMode: MessagesDatabaseServiceMode.Firestore,
    notificationServiceMode: NotificationServiceMode.FirebaseCloudMessaging,
  );

  static FirebaseSettings firebaseSettings = FirebaseSettings(
    usersCollectionName: CustomFirebaseSettings.USERS_COLLECTION_NAME,
    usernameKey: CustomFirebaseSettings.USERNAME_KEY,
    userProfilePhotoUrlKey: CustomFirebaseSettings.USER_PROFILE_PHOTO_URL_KEY,
    userNotificationIdKey: CustomFirebaseSettings.USER_NOTIFICATION_ID_KEY,
    fcmServerKey: CustomFirebaseSettings.FCM_SERVER_KEY,
  );

  static LanguageSettings languageSettings = LanguageSettings();

  static ContactsPageSettings contactsPageSettings = ContactsPageSettings();

  static MessagesPageSettings messagesPageSettings = MessagesPageSettings();
}
