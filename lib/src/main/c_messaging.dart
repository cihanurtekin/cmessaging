import 'package:c_messaging/src/model/user.dart';
import 'package:c_messaging/src/settings/contacts_page_settings.dart';
import 'package:c_messaging/src/settings/debug_settings.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/language_settings.dart';
import 'package:c_messaging/src/settings/messages_page_settings.dart';
import 'package:c_messaging/src/settings/service_settings.dart';
import 'package:c_messaging/src/tools/locator.dart';
import 'package:c_messaging/src/tools/repositories.dart';
import 'package:c_messaging/src/view/contacts_page.dart';
import 'package:c_messaging/src/view/messages_page.dart';
import 'package:c_messaging/src/view_model/contacts_view_model.dart';
import 'package:c_messaging/src/view_model/messages_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CMessaging {
  CMessaging._();

  static CMessaging? _instance;

  static CMessaging get instance {
    if (_instance == null) {
      setupLocator();
      _instance = CMessaging._();
    }
    return _instance!;
  }

  String? _userId;

  Repositories? _repositories;

  ServiceSettings? _serviceSettings;
  FirebaseSettings? _firebaseSettings;
  DebugSettings? _debugSettings;
  ContactsPageSettings? _contactsPageSettings;
  MessagesPageSettings? _messagesPageSettings;
  LanguageSettings? _languageSettings;

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

  init(
    BuildContext context, {
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
    _initRepositories(context);
  }

  bool get isInitialized {
    return _userId != null;
  }

  _initRepositories(BuildContext context) {
    if (_debugSettings != null &&
        _firebaseSettings != null &&
        _serviceSettings != null) {
      _repositories = Repositories(
        debugSettings: _debugSettings!,
        firebaseSettings: _firebaseSettings!,
        serviceSettings: _serviceSettings!,
      );
      _repositories?.createAll(context);
    }
  }

  pushContactsPage(BuildContext context) {
    if (isInitialized &&
        _contactsPageSettings != null &&
        _messagesPageSettings != null &&
        _firebaseSettings != null &&
        _languageSettings != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ChangeNotifierProvider(
            create: (context) => ContactsViewModel(
              userId: _userId!,
              paginationLimitForFirstQuery:
                  _contactsPageSettings!.paginationLimitForFirstQuery,
              paginationLimitForOtherQueries:
                  _contactsPageSettings!.paginationLimitForOtherQueries,
              messagesPageSettings: _messagesPageSettings!,
              firebaseSettings: _firebaseSettings!,
              languageSettings: _languageSettings!,
            ),
            child: MessageContactsPage(
              _contactsPageSettings!,
              _languageSettings!,
            ),
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
    User contactUser = User(
      userId: contactUserId,
      username: contactUsername,
      profilePhotoUrl: contactProfilePhotoUrl,
      notificationId: contactNotificationId,
    );
    if (isInitialized &&
        _messagesPageSettings != null &&
        _firebaseSettings != null &&
        _languageSettings != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ChangeNotifierProvider(
            create: (context) => MessagesViewModel(
              userId: _userId!,
              contactUser: contactUser,
              paginationLimitForFirstQuery:
                  _messagesPageSettings!.paginationLimitForFirstQuery,
              paginationLimitForOtherQueries:
                  _messagesPageSettings!.paginationLimitForOtherQueries,
              firebaseSettings: _firebaseSettings!,
              languageSettings: _languageSettings!,
            ),
            child: MessagesPage(_messagesPageSettings!, _languageSettings!),
          ),
        ),
      );
    }
  }
}
