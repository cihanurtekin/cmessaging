import 'package:c_messaging/src/helper/repositories.dart';
import 'package:c_messaging/src/model/custom_user.dart';
import 'package:c_messaging/src/settings/contacts_page_settings.dart';
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
  String _userId;

  ServiceSettings _serviceSettings;
  FirebaseSettings _firebaseSettings;
  ContactsPageSettings _contactsPageSettings;
  MessagesPageSettings _messagesPageSettings;
  LanguageSettings _languageSettings;

  Repositories _repositories;

  Function(int notificationId, String title, String body,
      String receiverNotificationId) _onMessageReceived;

  CMessaging({
    @required String userId,
    @required ServiceSettings serviceSettings,
    @required FirebaseSettings firebaseSettings,
    ContactsPageSettings contactsPageSettings,
    MessagesPageSettings messagesPageSettings,
    LanguageSettings languageSettings,
    Function onMessageReceived,
  }) {
    _userId = userId;
    _serviceSettings = serviceSettings;
    _firebaseSettings = firebaseSettings;
    _contactsPageSettings = contactsPageSettings;
    _messagesPageSettings = messagesPageSettings;
    _languageSettings = languageSettings;
    _onMessageReceived = onMessageReceived;
    _initRepositories();
    _checkNullAndSetDefaultValues();
  }

  _initRepositories() {
    _repositories = Repositories(
      firebaseSettings: _firebaseSettings,
      serviceSettings: _serviceSettings,
    );
    _repositories.createAll(_onMessageReceived);
  }

  _checkNullAndSetDefaultValues() {
    _contactsPageSettings ??= ContactsPageSettings();
    _messagesPageSettings ??= MessagesPageSettings();
    _languageSettings ??= LanguageSettings();
  }

  pushContactsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ChangeNotifierProvider(
          create: (context) => ContactsViewModel(
            userId: _userId,
            settings: _contactsPageSettings,
            messagesPageSettings: _messagesPageSettings,
            firebaseSettings: _firebaseSettings,
            languageSettings: _languageSettings,
            messagesDatabaseRepository:
                _repositories.messagesDatabaseRepository,
            customUserDatabaseRepository:
                _repositories.customUserDatabaseRepository,
          ),
          child: MessageContactsPage(),
        ),
      ),
    );
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ChangeNotifierProvider(
          create: (context) => MessagesViewModel(
            userId: _userId,
            contactUser: contactUser,
            settings: _messagesPageSettings,
            firebaseSettings: _firebaseSettings,
            languageSettings: _languageSettings,
            messagesDatabaseRepository:
                _repositories.messagesDatabaseRepository,
          ),
          child: MessagesPage(),
        ),
      ),
    );
  }
}
