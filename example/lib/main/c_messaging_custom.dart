import 'package:c_messaging/c_messaging.dart';

class CMessagingCustom {
  static final CMessagingCustom _cMessagingCustom =
      CMessagingCustom._internal();

  factory CMessagingCustom() {
    return _cMessagingCustom;
  }

  CMessagingCustom._internal();

  CMessaging _cMessaging;

  ServiceSettings _serviceSettings = ServiceSettings(
    userDatabaseServiceMode: UserDatabaseServiceMode.Firestore,
    messagesDatabaseServiceMode: MessagesDatabaseServiceMode.Firestore,
    notificationServiceMode: NotificationServiceMode.FirebaseCloudMessaging,
  );

  FirebaseSettings _firebaseSettings = FirebaseSettings(
    usersCollectionName: "users",
    usernameKey: 'username',
    userProfilePhotoUrlKey: 'profilePhoto',
    userNotificationIdKey: 'notificationId',
    fcmServerKey: '',
  );

  LanguageSettings _languageSettings = LanguageSettings();

  ContactsPageSettings _contactsPageSettings = ContactsPageSettings();
  MessagesPageSettings _messagesPageSettings = MessagesPageSettings();

  CMessaging get() {
    if (_cMessaging == null) {
      _cMessaging = CMessaging();
      _cMessaging.init(
        userId: "",
        serviceSettings: _serviceSettings,
        firebaseSettings: _firebaseSettings,
        languageSettings: _languageSettings,
        contactsPageSettings: _contactsPageSettings,
        messagesPageSettings: _messagesPageSettings,
      );
    }

    return _cMessaging;
  }
}
