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
  final bool firestorePersistenceEnabledUser;

  // Message Database Settings
  final String messagesCollectionName;
  final String messagesOfUserCollectionName;
  final String messagesOfChannelCollectionName;
  final String contactsCollectionName;
  final bool firestorePersistenceEnabledMessages;
  final bool firestorePersistenceEnabledChannels;

  // Channel Database Settings
  final String channelsCollectionName;

  // Firebase Storage Settings
  final String usersFolderName;
  final String messagesFolderName;
  final String channelsFolderName;

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
    this.messagesOfChannelCollectionName = 'messages',
    this.channelsCollectionName = 'channels',
    this.usersFolderName = 'users',
    this.messagesFolderName = 'messages',
    this.channelsFolderName = 'channels',
    this.firestorePersistenceEnabledUser = false,
    this.firestorePersistenceEnabledMessages = false,
    this.firestorePersistenceEnabledChannels = false,
    this.fcmSettings,
  });
}
