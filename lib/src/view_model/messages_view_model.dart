import 'dart:async';
import 'dart:io';

import 'package:c_messaging/src/base/message_database_base.dart';
import 'package:c_messaging/src/custom_widgets/photo_picker.dart';
import 'package:c_messaging/src/dialog/dialog_helper.dart';
import 'package:c_messaging/src/dialog/loading_dialog.dart';
import 'package:c_messaging/src/repository/storage_repository.dart';
import 'package:c_messaging/src/tools/locator.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/user.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/repository/message_database_repository.dart';
import 'package:c_messaging/src/repository/notification_repository.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/language_settings.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

enum MessagesViewState {
  idle,
  loadingFirstQuery,
  loadingOtherQueries,
  uploadingImage,
  deleting,
  error,
}

class MessagesViewModel with ChangeNotifier {
  MessageDatabaseRepository _messagesDatabaseRepository =
      locator<MessageDatabaseRepository>();
  NotificationRepository _notificationRepository =
      locator<NotificationRepository>();
  StorageRepository _storageRepository = locator<StorageRepository>();

  final ScrollController _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  MessagesViewState _state = MessagesViewState.idle;

  MessagesViewState get state => _state;

  set state(MessagesViewState value) {
    _state = value;
    notifyListeners();
  }

  List<Message> _messages = [];

  List<Message> get messages => _messages;

  dynamic _lastItemToStartAfter;

  StreamSubscription? _newMessageSubscription;

  final String _currentDatabaseUserId;

  String get currentDatabaseUserId => _currentDatabaseUserId;

  final User _contactUser;

  User get contactUser => _contactUser;

  final FirebaseSettings firebaseSettings;
  final LanguageSettings languageSettings;

  final int _paginationLimitForFirstQuery;
  final int _paginationLimitForOtherQueries;

  MessagesViewModel({
    required String userId,
    required User contactUser,
    required int paginationLimitForFirstQuery,
    required int paginationLimitForOtherQueries,
    required this.firebaseSettings,
    required this.languageSettings,
  })  : _currentDatabaseUserId = userId,
        _contactUser = contactUser,
        _paginationLimitForFirstQuery = paginationLimitForFirstQuery,
        _paginationLimitForOtherQueries = paginationLimitForOtherQueries {
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearMessages();
      _getMessages(_paginationLimitForFirstQuery);
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_state == MessagesViewState.idle) {
        _state = MessagesViewState.loadingOtherQueries;
        _getMessages(_paginationLimitForOtherQueries);
      }
    }
  }

  void _clearMessages() {
    _messages = [];
    _lastItemToStartAfter = null;
  }

  void refreshMessages() {
    state = MessagesViewState.loadingFirstQuery;
    _clearMessages();
    _getMessages(_paginationLimitForFirstQuery);
  }

  void _getMessages(int paginationLimit) async {
    try {
      List messageList = await _messagesDatabaseRepository.getMessages(
        _currentDatabaseUserId,
        _contactUser.userId,
        ListType.messages,
        _lastItemToStartAfter,
        paginationLimit,
      );
      _messages.addAll(
        List.from(messageList[0]),
      );
      _lastItemToStartAfter = messageList[1];
      if (_newMessageSubscription == null) {
        _addListener();
      }
      state = MessagesViewState.idle;
    } catch (e) {
      debugPrint('MessagesViewModel / _getMessages: ${e.toString()}');
      state = MessagesViewState.error;
    }
  }

  @override
  dispose() {
    _newMessageSubscription?.cancel();
    _clearMessages();
    super.dispose();
  }

  Future<Message?> deleteMessage(int index) async {
    Message messageToDelete = _messages[index];
    _messages.removeAt(index);
    //messages.removeWhere((m) => m.messageUid == messageToDelete.messageUid);
    state = MessagesViewState.deleting;
    bool isLastMessage = index == 0;
    Message newLastMessage = isLastMessage ? _messages[1] : _messages[0];
    try {
      //newLastMessage.contactUser = _contactUser;
      MessageDatabaseResult result =
          await _messagesDatabaseRepository.deleteMessage(
              _currentDatabaseUserId,
              messageToDelete,
              isLastMessage,
              newLastMessage);
      /*if (result == MessagesBaseResult.Success) {
        messages
            .removeWhere((m) => m.messageUid == messageToDelete.messageUid);
      }*/
    } catch (e) {
      print("MessagesViewModel / deleteMessage : ${e.toString()}");
    } finally {
      state = MessagesViewState.idle;
    }
    if (isLastMessage) {
      //_contactsViewModel.updateLastMessageCallback(newLastMessage);
    }
    return newLastMessage;
  }

  void sendImageMessage(BuildContext context) async {
    File? imageFile = await PhotoPicker(
      takePhotoText: languageSettings.takePhoto,
      chooseFromGalleryText: languageSettings.chooseFromGallery,
      cancelText: languageSettings.cancel,
    ).pick(context);
    if (imageFile != null) {
      bool? willSend = await DialogHelper.showPhotoDialog(
        context,
        imageFile,
        languageSettings.send,
        languageSettings.cancel,
      );
      if (willSend != null && willSend) {
        _sendImageMessage(context, imageFile);
      }
    }
  }

  Future<Message?> _sendImageMessage(
    BuildContext context,
    File imageFile,
  ) async {
    LoadingAlertDialog dialog = LoadingAlertDialog(
      loadingText: languageSettings.uploadingImage,
    );
    try {
      DialogHelper.show(context, dialog, barrierDismissible: false);
      String messageId = Uuid().v4();
      String? imageUrl = await _storageRepository.uploadMessageImage(
        _currentDatabaseUserId,
        _contactUser.userId,
        messageId,
        imageFile,
      );
      dialog.cancel(context);
      if (imageUrl != null && imageUrl.trim().isNotEmpty) {
        return await sendMessage(
          imageUrl,
          messageId: messageId,
          messageType: MessageType.image,
        );
      } else {
        print("MessagesViewModel / sendImageMessage : Image url is null");
        return null;
      }
    } catch (e) {
      dialog.cancel(context);
      print("MessagesViewModel / sendImageMessage : ${e.toString()}");
      return null;
    }
  }

  Future<Message?> sendMessage(
    String messageBody, {
    String? messageId,
    int messageType = MessageType.text,
  }) async {
    Message? newLastMessage = await _sendMessage(
      messageId ?? Uuid().v4(),
      messageBody,
      messageType: messageType,
    );
    //contactsViewModel.updateLastMessageCallback(newLastMessage);
    //contactsViewModel.updateMessageStatusCallback(newLastMessage);
    return newLastMessage;
  }

  Future<Message?> _sendMessage(
    String messageId,
    String messageBody, {
    int messageType = MessageType.text,
  }) async {
    if (state == MessagesViewState.idle && messageBody.trim().isNotEmpty) {
      Message m = Message(
        messageId: messageId,
        senderId: _currentDatabaseUserId,
        receiverId: _contactUser.userId,
        messageBody: messageBody.trim(),
        sendStatus: MessageSendStatus.waiting,
        // will be changed on the service
        dateOfCreated: DateTime.now(),
        messageType: messageType,
      );
      m.contactUser = _contactUser;
      _messages.insert(0, m);
      notifyListeners();
      try {
        MessageDatabaseResult result = await _messagesDatabaseRepository
            .sendMessage(_currentDatabaseUserId, m);
        if (result == MessageDatabaseResult.Success) {
          //m.status = Message.STATUS_SENT;
          _sendNotification(m.messageBody);
        } else {
          updateMessageStatus(m, MessageSendStatus.error);
        }
        //notifyListeners();
      } catch (e) {
        print("MessagesViewModel / sendMessage : ${e.toString()}");
      }
      return m;
    }
    return null;
  }

  void _sendNotification(String messageBody) {
    String notificationId = contactUser.notificationId;
    if (notificationId.isNotEmpty &&
        notificationId != firebaseSettings.defaultNotificationId) {
      _notificationRepository.sendNotification(
        title: contactUser.username,
        body: messageBody,
        receiverNotificationId: notificationId,
        currentUserId: _currentDatabaseUserId,
      );
    }
  }

  Future<void> retryToSendMessage(int index, Message message) async {
    _messages.removeAt(index);
    await sendMessage(message.messageBody, messageId: message.messageId);
  }

  void _addListener() {
    _newMessageSubscription = _messagesDatabaseRepository
        .addListenerToMessages(_currentDatabaseUserId, _contactUser.userId)
        .listen((messageList) {
      if (messageList.isNotEmpty) {
        Message? newMessage = messageList[0];

        if (newMessage != null) {
          //if (_listenFirstQuery) {
          //    _listenFirstQuery = false;
          // } else {
          newMessageHandler(newMessage);
          // }
        }
      }
    });
  }

  void updateMessageStatus(Message message, int status) {
    for (Message m in _messages) {
      if (m.messageId == message.messageId) {
        m.updateSendStatus(status);
        return;
      }
    }
  }

  void newMessageHandler(Message newMessage) {
    for (Message m in _messages) {
      if (m.messageId == newMessage.messageId) {
        m.update({
          Message.messageIdKey: newMessage.messageId,
          Message.statusKey: newMessage.status,
          Message.sendStatusKey: newMessage.sendStatus,
          Message.dateOfCreatedKey: newMessage.dateOfCreated,
        });
        return;
      }
    }
    _messages.insert(0, newMessage);
    notifyListeners();
  }

  bool isMessageAlreadyInList(Message message) {
    for (Message m in _messages) {
      if (m.messageId == message.messageId) return true;
    }
    return false;
  }

  void onBackButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }
}
