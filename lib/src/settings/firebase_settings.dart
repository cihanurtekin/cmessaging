import 'package:c_messaging/src/settings/fcm_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

class FirebaseSettings implements SettingsBase {
  // Users Database Settings
  final String usersCollectionName;
  final String usernameKey;
  final String userProfilePhotoUrlKey;
  final String userNotificationIdKey;
  final String defaultUsername;
  final String defaultProfilePhotoUrl;
  final String defaultNotificationId;
  final bool firestorePersistenceEnabledCustomUser;

  // Messages Database Settings
  final String messagesCollectionName;
  final String messagesOfUserCollectionName;
  final String contactsCollectionName;
  final bool firestorePersistenceEnabledMessages;

  // Firebase Storage Settings
  final String storageMessagesFolderName;

  // Firebase Cloud Messaging Settings
  final FcmSettings? fcmSettings;

  FirebaseSettings({
    required this.usersCollectionName,
    required this.usernameKey,
    required this.userProfilePhotoUrlKey,
    required this.userNotificationIdKey,
    //this.fcmNotificationUrl = 'https://fcm.googleapis.com/fcm/send',
    this.defaultUsername = 'Unknown User',
    this.defaultProfilePhotoUrl = '',
    this.defaultNotificationId = '',
    this.messagesCollectionName = 'messages',
    this.contactsCollectionName = 'contacts',
    this.messagesOfUserCollectionName = 'messages',
    this.storageMessagesFolderName = 'messages',
    this.firestorePersistenceEnabledCustomUser = false,
    this.firestorePersistenceEnabledMessages = false,
    this.fcmSettings,
  });
}
