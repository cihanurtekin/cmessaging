import 'dart:async';

import 'package:c_messaging/src/base/messages_database_base.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/custom_user.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/repository/custom_user_database_repository.dart';
import 'package:c_messaging/src/repository/messages_database_repository.dart';
import 'package:c_messaging/src/repository/notification_repository.dart';
import 'package:c_messaging/src/settings/contacts_page_settings.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/language_settings.dart';
import 'package:c_messaging/src/settings/messages_page_settings.dart';
import 'package:c_messaging/src/view/messages_page.dart';
import 'package:c_messaging/src/view_model/messages_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum ContactsViewState {
  Idle,
  LoadingFirstQuery,
  LoadingOtherQueries,
  Deleting,
  Error
}

class ContactsViewModel with ChangeNotifier {
  ContactsViewState _state = ContactsViewState.LoadingFirstQuery;

  ContactsViewState get state => _state;

  set state(ContactsViewState value) {
    _state = value;
    notifyListeners();
  }

  StreamSubscription _contactUpdateSubscription;
  bool _isFirstQuery = true;

  List<Message> _messages = [];

  List<Message> get messages => _messages;

  dynamic _lastMessageToStartAfter;

  String _currentDatabaseUserId;

  final ContactsPageSettings settings;
  final MessagesPageSettings messagesPageSettings;
  final FirebaseSettings firebaseSettings;
  final LanguageSettings languageSettings;

  MessagesDatabaseRepository _messagesDatabaseRepository;
  CustomUserDatabaseRepository _customUserDatabaseRepository;
  NotificationRepository _notificationRepository;

  ContactsViewModel({
    @required String userId,
    @required this.settings,
    @required this.messagesPageSettings,
    @required this.firebaseSettings,
    @required this.languageSettings,
    @required MessagesDatabaseRepository messagesDatabaseRepository,
    @required CustomUserDatabaseRepository customUserDatabaseRepository,
    @required NotificationRepository notificationRepository,
  }) {
    _currentDatabaseUserId = userId;
    _messagesDatabaseRepository = messagesDatabaseRepository;
    _customUserDatabaseRepository = customUserDatabaseRepository;
    _notificationRepository = notificationRepository;
    _getMessagesWithPagination(settings.paginationLimitForFirstQuery).then((_) {
      _addListener();
    });
  }

  @override
  dispose() {
    if (_contactUpdateSubscription != null) {
      _contactUpdateSubscription.cancel();
    }
    super.dispose();
  }

  void refreshContacts() {
    state = ContactsViewState.LoadingFirstQuery;
    _messages = [];
    _lastMessageToStartAfter = null;
    _getMessagesWithPagination(settings.paginationLimitForFirstQuery);
  }

  Future<void> getMessagesWithPagination() async {
    await _getMessagesWithPagination(settings.paginationLimitForOtherQueries);
  }

  Future<void> _getMessagesWithPagination(int paginationLimit) async {
    List messageListAndLastMessage;

    if (_currentDatabaseUserId != null) {
      if (hasMessage()) {
        state = ContactsViewState.LoadingFirstQuery;
      } else {
        state = ContactsViewState.LoadingOtherQueries;
      }
      try {
        messageListAndLastMessage = await _messagesDatabaseRepository
            .getMessagesAndLastMessageWithPagination(
          _currentDatabaseUserId,
          '',
          ListType.Contacts,
          _lastMessageToStartAfter,
          paginationLimit,
        );

        for (Message m in messageListAndLastMessage[0]) {
          CustomUser customUser =
              await _customUserDatabaseRepository.getUser(m.contactId);
          m.contactUser = customUser;
        }

        messages.addAll(messageListAndLastMessage[0]);
        _lastMessageToStartAfter = messageListAndLastMessage[1];
        state = ContactsViewState.Idle;
      } catch (e) {
        print(
            "ContactsViewModel / getMessagesWithPagination : ${e.toString()}");
        state = ContactsViewState.Error;
      }
    }
  }

  bool hasMessage() {
    return messages.length > 0;
  }

  bool isUserSender(Message message) {
    bool result = true;
    if (_currentDatabaseUserId != null) {
      result = message.senderId == _currentDatabaseUserId;
    }
    return result;
  }

  Future<MessagesDatabaseResult> deleteMessage(String currentUserId,
      Message message, bool isLastMessage, Message newLastMessage) {
    // TODO: implement deleteMessage
    return null;
  }

  Message getMessageWithIndex(int index) {
    if (hasMessage()) {
      return messages[index];
    } else {
      return null;
    }
  }

  String getMessageDateText(BuildContext context, int index) {
    return DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
        .format(getMessageWithIndex(index).dateOfCreated);
  }

  Future<MessagesDatabaseResult> deleteAllMessagesOfContactWithIndex(
      int index) async {
    MessagesDatabaseResult result = MessagesDatabaseResult.Error;
    Message messageToDelete = getMessageWithIndex(index);
    if (_currentDatabaseUserId != null) {
      state = ContactsViewState.Deleting;
      try {
        result = await _messagesDatabaseRepository.deleteAllMessagesOfContact(
            _currentDatabaseUserId, messageToDelete.contactId);
      } catch (e) {
        print(
            "ContactsViewState / deleteAllMessagesOfContact : ${e.toString()}");
      }
      state = ContactsViewState.Idle;
    }
    return result;
  }

  void _addListener() async {
    if (_currentDatabaseUserId != null) {
      _contactUpdateSubscription = _messagesDatabaseRepository
          .addListenerToContacts(_currentDatabaseUserId, "")
          .listen((messageList) {
        if (messageList != null && messageList.isNotEmpty) {
          Message newMessage = messageList[0];

          if (newMessage != null) {
            newMessageHandler(newMessage);
          }
        }
      });
    }
  }

  newMessageHandler(Message newMessage) {
    if (_isFirstQuery) {
      _isFirstQuery = false;
    } else {
      String contactIdToRemove = "";
      Message messageToAdd = newMessage;
      for (Message m in _messages) {
        if (m.contactId == messageToAdd.contactId) {
          CustomUser contactUser = m.contactUser;
          messageToAdd.contactUser = contactUser;
          contactIdToRemove = m.contactId;
          break;
        }
      }
      if (contactIdToRemove.trim().isNotEmpty) {
        _messages.removeWhere((mess) => mess.contactId == contactIdToRemove);
      }
      _messages.insert(0, messageToAdd);
      notifyListeners();
    }
  }

  updateLastMessageCallback(Message message) {
    int index = messages.indexWhere((m) => m.contactId == message.contactId);
    if (index >= 0) {
      messages[index] = message;
      messages.sort((m1, m2) {
        return m2.dateOfCreated.compareTo(m1.dateOfCreated);
      });
      notifyListeners();
    }
  }

  updateMessageStatusCallback(Message mess) {
    Message message = messages.firstWhere((m) => m.contactId == mess.contactId,
        orElse: () => null);
    if (message != null) {
      message.status = mess.status;
      notifyListeners();
    }
  }

  openMessagesPage(BuildContext context, int index) {
    Message message = getMessageWithIndex(index);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ChangeNotifierProvider(
          create: (context) => MessagesViewModel(
            userId: _currentDatabaseUserId,
            contactUser: message.contactUser,
            settings: messagesPageSettings,
            firebaseSettings: firebaseSettings,
            languageSettings: languageSettings,
            messagesDatabaseRepository: _messagesDatabaseRepository,
            notificationRepository: _notificationRepository,
          ),
          child: MessagesPage(),
        ),
      ),
    );
  }
}
