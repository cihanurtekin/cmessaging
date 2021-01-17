class CustomFirebaseSettings {

  // Users Database Settings
  static const String USERS_COLLECTION_NAME = 'users';
  static const String USERNAME_KEY = 'username';
  static const String USER_PROFILE_PHOTO_URL_KEY = 'profilePhoto';
  static const String USER_NOTIFICATION_ID_KEY = 'notificationId';
  static const String FCM_SERVER_KEY = '';

  static const String DEFAULT_USERNAME = 'Unknown User';
  static const String DEFAULT_NAME_SURNAME = 'Unknown User';
  static const String DEFAULT_PROFILE_PHOTO_URL = '';
  static const bool FIRESTORE_PERSISTENCE_ENABLED_USERS = false;

  // Messages Database Settings
  //static const String MESSAGES_COLLECTION_NAME = 'messages';
  //static const String MESSAGES_OF_USER_COLLECTION_NAME = 'messages';
  //static const String CONTACTS_COLLECTION_NAME = 'contacts';
  //static const bool FIRESTORE_PERSISTENCE_ENABLED_MESSAGES = false;

  // Firebase Cloud Messaging Settings
  //static const String FCM_NOTIFICATION_URL = 'https://fcm.googleapis.com/fcm/send';
  //static const String FCM_SERVER_KEY = 'PUT SERVER KEY HERE';

  // Firebase Storage Settings
  //static const String STORAGE_MESSAGES_FOLDER_NAME = 'messages';
}
