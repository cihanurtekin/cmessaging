import 'package:c_messaging/src/helper/locator.dart';
import 'package:c_messaging/src/helper/repositories.dart';
import 'package:c_messaging/src/model/custom_user.dart';
import 'package:c_messaging/src/settings/contacts_page_settings.dart';
import 'package:c_messaging/src/settings/debug_settings.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/language_settings.dart';
import 'package:c_messaging/src/settings/messages_page_settings.dart';
import 'package:c_messaging/src/settings/service_settings.dart';
import 'package:c_messaging/src/view/contacts_page.dart';
import 'package:c_messaging/src/view/messages_page.dart';
import 'package:c_messaging/src/view_model/contacts_view_model.dart';
import 'package:c_messaging/src/view_model/messages_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CMessaging {
  static final CMessaging _cMessaging = CMessaging._internal();

  factory CMessaging() {
    setupLocator();
    return _cMessaging;
  }

  CMessaging._internal();

  String? _userId;

  late Repositories _repositories;

  late ServiceSettings _serviceSettings;
  late FirebaseSettings _firebaseSettings;
  late DebugSettings _debugSettings;
  late ContactsPageSettings _contactsPageSettings;
  late MessagesPageSettings _messagesPageSettings;
  late LanguageSettings _languageSettings;

  set serviceSettings(ServiceSettings value) {
    _serviceSettings = value;
  }

  set firebaseSettings(FirebaseSettings value) {
    _firebaseSettings = value;
  }

  set contactsPageSettings(ContactsPageSettings value) {
    _contactsPageSettings = value;
  }

  set messagesPageSettings(MessagesPageSettings value) {
    _messagesPageSettings = value;
  }

  set languageSettings(LanguageSettings value) {
    _languageSettings = value;
  }

  init({
    required String userId,
    required ServiceSettings serviceSettings,
    required FirebaseSettings firebaseSettings,
    DebugSettings? debugSettings,
    ContactsPageSettings? contactsPageSettings,
    MessagesPageSettings? messagesPageSettings,
    LanguageSettings? languageSettings,
  }) {
    _userId = userId;
    _serviceSettings = serviceSettings;
    _firebaseSettings = firebaseSettings;
    _debugSettings = debugSettings ?? DebugSettings();
    _contactsPageSettings = contactsPageSettings ?? ContactsPageSettings();
    _messagesPageSettings = messagesPageSettings ?? MessagesPageSettings();
    _languageSettings = languageSettings ?? LanguageSettings();
    _initRepositories();
  }

  bool get isInitialized {
    return _userId != null;
  }

  _initRepositories() {
    _repositories = Repositories(
      debugSettings: _debugSettings,
      firebaseSettings: _firebaseSettings,
      serviceSettings: _serviceSettings,
    );
    _repositories.createAll();
  }

  pushContactsPage(BuildContext context) {
    if (isInitialized) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ChangeNotifierProvider(
            create: (context) => ContactsViewModel(
              userId: _userId!,
              settings: _contactsPageSettings,
              messagesPageSettings: _messagesPageSettings,
              firebaseSettings: _firebaseSettings,
              languageSettings: _languageSettings,
            ),
            child: MessageContactsPage(),
          ),
        ),
      );
    }
  }

  pushMessagesPage(
    BuildContext context,
    String contactUserId,
    String contactUsername,
    String contactProfilePhotoUrl,
    String contactNotificationId,
  ) {
    CustomUser contactUser = CustomUser(
      userId: contactUserId,
      username: contactUsername,
      profilePhotoUrl: contactProfilePhotoUrl,
      notificationId: contactNotificationId,
    );
    if (isInitialized) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ChangeNotifierProvider(
            create: (context) => MessagesViewModel(
              userId: _userId!,
              contactUser: contactUser,
              settings: _messagesPageSettings,
              firebaseSettings: _firebaseSettings,
              languageSettings: _languageSettings,
            ),
            child: MessagesPage(),
          ),
        ),
      );
    }
  }
}
