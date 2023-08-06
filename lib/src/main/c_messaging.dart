import 'package:c_messaging/src/model/user.dart';
import 'package:c_messaging/src/settings/channels_page_settings.dart';
import 'package:c_messaging/src/settings/contacts_page_settings.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/language_settings.dart';
import 'package:c_messaging/src/settings/messages_page_settings.dart';
import 'package:c_messaging/src/settings/service_settings.dart';
import 'package:c_messaging/src/tools/locator.dart';
import 'package:c_messaging/src/tools/repositories.dart';
import 'package:c_messaging/src/view/channels_page.dart';
import 'package:c_messaging/src/view/contacts_page.dart';
import 'package:c_messaging/src/view/messages_page.dart';
import 'package:c_messaging/src/view_model/channels_view_model.dart';
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
  ContactsPageSettings? _contactsPageSettings;
  MessagesPageSettings? _messagesPageSettings;
  ChannelsPageSettings? _channelsPageSettings;
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

  set channelsPageSettings(ChannelsPageSettings value) {
    _channelsPageSettings = value;
  }

  set languageSettings(LanguageSettings value) {
    _languageSettings = value;
  }

  init(
    BuildContext context, {
    required String userId,
    required ServiceSettings serviceSettings,
    required FirebaseSettings firebaseSettings,
    ContactsPageSettings? contactsPageSettings,
    MessagesPageSettings? messagesPageSettings,
    ChannelsPageSettings? channelsPageSettings,
    LanguageSettings? languageSettings,
  }) {
    _userId = userId;
    _serviceSettings = serviceSettings;
    _firebaseSettings = firebaseSettings;
    _contactsPageSettings = contactsPageSettings ?? ContactsPageSettings();
    _messagesPageSettings = messagesPageSettings ?? MessagesPageSettings();
    _channelsPageSettings = channelsPageSettings ?? ChannelsPageSettings();
    _languageSettings = languageSettings ?? LanguageSettings();
    _initRepositories(context);
  }

  bool get isInitialized {
    return _userId != null;
  }

  _initRepositories(BuildContext context) {
    if (_firebaseSettings != null && _serviceSettings != null) {
      _repositories = Repositories(
        firebaseSettings: _firebaseSettings!,
        serviceSettings: _serviceSettings!,
      );
      _repositories?.createAll(context);
    }
  }

  Widget? ContactsPage() {
    if (isInitialized &&
        _contactsPageSettings != null &&
        _messagesPageSettings != null &&
        _firebaseSettings != null &&
        _languageSettings != null) {
      return ChangeNotifierProvider(
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
      );
    }
    return null;
  }

  Widget? ChannelsPage() {
    if (isInitialized &&
        _channelsPageSettings != null &&
        _messagesPageSettings != null &&
        _firebaseSettings != null &&
        _languageSettings != null) {
      return ChangeNotifierProvider(
        create: (context) => ChannelsViewModel(
          userId: _userId!,
          paginationLimitForFirstQuery:
              _contactsPageSettings!.paginationLimitForFirstQuery,
          paginationLimitForOtherQueries:
              _contactsPageSettings!.paginationLimitForOtherQueries,
          messagesPageSettings: _messagesPageSettings!,
          firebaseSettings: _firebaseSettings!,
          languageSettings: _languageSettings!,
        ),
        child: MessageChannelsPage(
          _channelsPageSettings!,
          _languageSettings!,
        ),
      );
    }
    return null;
  }

  Future<T?> pushContactsPage<T extends Object?>(BuildContext context) {
    if (isInitialized &&
        _contactsPageSettings != null &&
        _messagesPageSettings != null &&
        _firebaseSettings != null &&
        _languageSettings != null) {
      return Navigator.push<T>(
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
    return Future.value(null);
  }

  Future<T?> pushMessagesPage<T extends Object?>(
    BuildContext context,
    String contactUserId,
    String contactUsername,
    String contactProfilePhotoUrl,
    String contactNotificationId, {
    Widget? appBar,
  }) {
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
      return Navigator.push<T>(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ChangeNotifierProvider(
            create: (context) => MessagesViewModel.contact(
              userId: _userId!,
              contactUser: contactUser,
              paginationLimitForFirstQuery:
                  _messagesPageSettings!.paginationLimitForFirstQuery,
              paginationLimitForOtherQueries:
                  _messagesPageSettings!.paginationLimitForOtherQueries,
              firebaseSettings: _firebaseSettings!,
              languageSettings: _languageSettings!,
            ),
            child: MessagesPage(
              _messagesPageSettings!,
              _languageSettings!,
              appBar: appBar,
            ),
          ),
        ),
      );
    }
    return Future.value(null);
  }
}
