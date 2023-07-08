import 'dart:async';

import 'package:c_messaging/src/base/message_database_base.dart';
import 'package:c_messaging/src/tools/locator.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/user.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/repository/message_database_repository.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/language_settings.dart';
import 'package:c_messaging/src/settings/messages_page_settings.dart';
import 'package:c_messaging/src/view/messages_page.dart';
import 'package:c_messaging/src/view_model/messages_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

enum ContactsViewState {
  idle,
  loadingFirstQuery,
  loadingOtherQueries,
  deleting,
  error
}

class ContactsViewModel with ChangeNotifier {
  MessageDatabaseRepository _messagesDatabaseRepository =
      locator<MessageDatabaseRepository>();

  final ScrollController _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  ContactsViewState _state = ContactsViewState.loadingFirstQuery;

  ContactsViewState get state => _state;

  set state(ContactsViewState value) {
    _state = value;
    notifyListeners();
  }

  List<Message> _messages = [];

  List<Message> get messages => _messages;

  dynamic _lastItemToStartAfter;

  StreamSubscription? _contactUpdateSubscription;

  final String _currentDatabaseUserId;

  final MessagesPageSettings messagesPageSettings;
  final FirebaseSettings firebaseSettings;
  final LanguageSettings languageSettings;

  final int _paginationLimitForFirstQuery;
  final int _paginationLimitForOtherQueries;

  ContactsViewModel({
    required String userId,
    required int paginationLimitForFirstQuery,
    required int paginationLimitForOtherQueries,
    required this.messagesPageSettings,
    required this.firebaseSettings,
    required this.languageSettings,
  })  : _currentDatabaseUserId = userId,
        _paginationLimitForFirstQuery = paginationLimitForFirstQuery,
        _paginationLimitForOtherQueries = paginationLimitForOtherQueries {
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearContacts();
      _getMessages(_paginationLimitForFirstQuery);
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_state == ContactsViewState.idle) {
        _state = ContactsViewState.loadingOtherQueries;
        _getMessages(_paginationLimitForOtherQueries);
      }
    }
  }

  void _clearContacts() {
    _messages = [];
    _lastItemToStartAfter = null;
  }

  void refreshContacts() {
    state = ContactsViewState.loadingFirstQuery;
    _clearContacts();
    _getMessages(_paginationLimitForFirstQuery);
  }

  void _getMessages(int paginationLimit) async {
    try {
      List messageList = await _messagesDatabaseRepository.getMessages(
        _currentDatabaseUserId,
        '',
        ListType.contacts,
        _lastItemToStartAfter,
        paginationLimit,
      );
      _messages.addAll(
        List.from(messageList[0]),
      );
      _lastItemToStartAfter = messageList[1];
      if (_contactUpdateSubscription == null) {
        _addListener();
      }
      state = ContactsViewState.idle;
    } catch (e) {
      debugPrint('ContactsViewModel / _getMessages: ${e.toString()}');
      state = ContactsViewState.error;
    }
  }

  @override
  dispose() {
    _contactUpdateSubscription?.cancel();
    super.dispose();
  }

  bool isUserSender(Message message) {
    return message.senderId == _currentDatabaseUserId;
  }

  Future<MessageDatabaseResult> deleteMessage(
    String currentUserId,
    Message message,
    bool isLastMessage,
    Message newLastMessage,
  ) {
    return Future.value(MessageDatabaseResult.Error);
  }

  Future<MessageDatabaseResult> deleteAllMessagesOfContact(
    Message message,
  ) async {
    MessageDatabaseResult result = MessageDatabaseResult.Error;
    state = ContactsViewState.deleting;
    try {
      result = await _messagesDatabaseRepository.deleteAllMessagesOfContact(
        _currentDatabaseUserId,
        message.contactId,
      );
    } catch (e) {
      debugPrint(
        "ContactsViewState / deleteAllMessagesOfContact : ${e.toString()}",
      );
    }
    state = ContactsViewState.idle;

    return result;
  }

  void _addListener() async {
    _contactUpdateSubscription = _messagesDatabaseRepository
        .addListenerToContacts(_currentDatabaseUserId, "")
        .listen((messageList) {
      if (messageList.isNotEmpty) {
        Message? newMessage = messageList[0];

        if (newMessage != null) {
          newMessageHandler(newMessage);
        }
      }
    });
  }

  void newMessageHandler(Message newMessage) {
    String contactIdToRemove = "";
    Message messageToAdd = newMessage;
    for (Message m in _messages) {
      if (m.contactId == messageToAdd.contactId) {
        User? contactUser = m.contactUser;
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

  void updateLastMessageCallback(Message message) {
    int index = messages.indexWhere((m) => m.contactId == message.contactId);
    if (index >= 0) {
      messages[index] = message;
      messages.sort((m1, m2) {
        return m2.dateOfCreated.compareTo(m1.dateOfCreated);
      });
      notifyListeners();
    }
  }

  void updateMessageStatusCallback(Message mess) {
    Message? message = messages.firstWhereOrNull(
      (m) => m.contactId == mess.contactId,
    );
    if (message != null) {
      message.updateSendStatus(mess.sendStatus);
    }
  }

  void openMessagesPage(BuildContext context, Message message) {
    User? contactUser = message.contactUser;
    if (contactUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ChangeNotifierProvider(
            create: (context) => MessagesViewModel.contact(
              userId: _currentDatabaseUserId,
              contactUser: contactUser,
              paginationLimitForFirstQuery:
                  messagesPageSettings.paginationLimitForFirstQuery,
              paginationLimitForOtherQueries:
                  messagesPageSettings.paginationLimitForOtherQueries,
              firebaseSettings: firebaseSettings,
              languageSettings: languageSettings,
            ),
            child: MessagesPage(messagesPageSettings, languageSettings),
          ),
        ),
      );
    }
  }

  void onBackButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }
}
