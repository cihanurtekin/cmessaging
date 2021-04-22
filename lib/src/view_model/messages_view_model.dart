import 'dart:async';
import 'dart:io';

import 'package:c_messaging/src/base/messages_database_base.dart';
import 'package:c_messaging/src/custom_widgets/photo_picker.dart';
import 'package:c_messaging/src/dialog/dialog_helper.dart';
import 'package:c_messaging/src/helper/locator.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/custom_user.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/repository/messages_database_repository.dart';
import 'package:c_messaging/src/repository/notification_repository.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/language_settings.dart';
import 'package:c_messaging/src/settings/messages_page_settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

enum MessagesViewState {
  Idle,
  LoadingFirstQuery,
  LoadingOtherQueries,
  UploadingImage,
  Deleting,
  Error
}

class MessagesViewModel with ChangeNotifier {
  MessagesViewState _state = MessagesViewState.Idle;

  MessagesViewState get state => _state;

  set state(MessagesViewState value) {
    _state = value;
    notifyListeners();
  }

  StreamSubscription? _newMessageSubscription;

  /// It prevents to duplicate the last message
  //bool _listenFirstQuery = true;

  String? _currentDatabaseUserId;
  late CustomUser _contactUser;

  CustomUser get contactUser => _contactUser;

  List<Message> _messages = [];

  List<Message> get messages => _messages;

  dynamic _lastMessageToStartAfter;

  final MessagesPageSettings settings;
  final FirebaseSettings firebaseSettings;
  final LanguageSettings languageSettings;

  MessagesDatabaseRepository _messagesDatabaseRepository =
      locator<MessagesDatabaseRepository>();
  NotificationRepository _notificationRepository =
      locator<NotificationRepository>();

  MessagesViewModel({
    required String userId,
    required CustomUser contactUser,
    required this.settings,
    required this.firebaseSettings,
    required this.languageSettings,
  }) {
    _currentDatabaseUserId = userId;
    _contactUser = contactUser;
    _getMessagesWithPagination(settings.paginationLimitForFirstQuery).then((_) {
      _addListener();
    });
  }

  @override
  dispose() {
    _newMessageSubscription?.cancel();
    _messages.clear();
    _lastMessageToStartAfter = null;
    super.dispose();
  }

  Future<void> getMessagesWithPagination() async {
    await _getMessagesWithPagination(settings.paginationLimitForOtherQueries);
  }

  Future<void> _getMessagesWithPagination(int paginationLimit) async {
    List messageListAndLastMessage;

    if (_currentDatabaseUserId != null) {
      if (!hasMessage()) {
        state = MessagesViewState.LoadingFirstQuery;
      } else {
        state = MessagesViewState.LoadingOtherQueries;
      }
      try {
        messageListAndLastMessage = await _messagesDatabaseRepository
            .getMessagesAndLastMessageWithPagination(
          _currentDatabaseUserId!,
          _contactUser.userId,
          ListType.Messages,
          _lastMessageToStartAfter,
          paginationLimit,
        );
        _messages.addAll(messageListAndLastMessage[0]);
        _lastMessageToStartAfter = messageListAndLastMessage[1];
        state = MessagesViewState.Idle;
      } catch (e) {
        print(
            "MessagesViewModel / getMessagesWithPagination : ${e.toString()}");
        state = hasMessage() ? MessagesViewState.Idle : MessagesViewState.Error;
      }
    }
  }

  Future<Message?> deleteMessage(int index) async {
    Message messageToDelete = _messages[index];
    _messages.removeAt(index);
    //messages.removeWhere((m) => m.messageUid == messageToDelete.messageUid);
    state = MessagesViewState.Deleting;
    if (_currentDatabaseUserId != null) {
      bool isLastMessage = index == 0;
      Message newLastMessage = isLastMessage ? _messages[1] : _messages[0];
      try {
        //newLastMessage.contactUser = _contactUser;
        MessagesDatabaseResult result =
            await _messagesDatabaseRepository.deleteMessage(
                _currentDatabaseUserId!,
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
        state = MessagesViewState.Idle;
      }
      if (isLastMessage) {
        //_contactsViewModel.updateLastMessageCallback(newLastMessage);
      }
      return newLastMessage;
    }
    return null;
  }

  sendImageMessage(BuildContext context) async {
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
    // TODO: Open when implemet repository ** Important **
    /*LoadingAlertDialog dialog =
        LoadingAlertDialog(loadingText: Sentences.uploadingImage());
    DialogHelper.show(context, dialog, barrierDismissible: false);
    try {
      String randomId = Message.generateRandomId();
      String imageUrl = await _storageRepository.uploadMessageImage(
          _currentDatabaseUserId,
          _contactUserId,
          randomId,
          imageFile);
      dialog.cancel(context);
      if (imageUrl != null && imageUrl.trim().isNotEmpty) {
        return await sendMessage(imageUrl,
            messageType: Message.MESSAGE_TYPE_IMAGE, randomIdParam: randomId);
      } else {
        print("MessagesViewModel / sendImageMessage : Image url is null");
        return null;
      }
    } catch (e) {
      dialog.cancel(context);
      print("MessagesViewModel / sendImageMessage : ${e.toString()}");
      return null;
    }*/
  }

  sendMessage(String messageBody) async {
    Message? newLastMessage = await _sendMessage(messageBody);
    //contactsViewModel.updateLastMessageCallback(newLastMessage);
    //contactsViewModel.updateMessageStatusCallback(newLastMessage);
  }

  Future<Message?> _sendMessage(
    String messageBody, {
    String randomIdParam = '',
    int messageType = Message.MESSAGE_TYPE_TEXT,
  }) async {
    if (_currentDatabaseUserId != null &&
        state == MessagesViewState.Idle &&
        messageBody.trim().isNotEmpty) {
      Message m = Message(
        senderId: _currentDatabaseUserId!,
        receiverId: _contactUser.userId,
        messageBody: messageBody.trim(),
        status: Message.STATUS_WAITING,
        // will be changed on the service
        dateOfCreated: DateTime.now(),
        messageType: messageType,
        randomIdParam: randomIdParam,
      );
      m.contactUser = _contactUser;
      _messages.insert(0, m);
      notifyListeners();
      try {
        MessagesDatabaseResult result = await _messagesDatabaseRepository
            .sendMessage(_currentDatabaseUserId!, m);
        if (result == MessagesDatabaseResult.Success) {
          //m.status = Message.STATUS_SENT;
          _sendNotification(m.messageBody);
        } else {
          updateMessageStatus(m, Message.STATUS_ERROR);
        }
        //notifyListeners();
      } catch (e) {
        print("MessagesViewModel / sendMessage : ${e.toString()}");
      }
      return m;
    }
    return null;
  }

  _sendNotification(String messageBody) {
    String ntfId = contactUser.notificationId;
    if (ntfId.isNotEmpty &&
        contactUser.notificationId != firebaseSettings.defaultNotificationId) {
      _notificationRepository.sendNotification(
        "",
        messageBody,
        _contactUser.notificationId,
      );
    }
  }

  Future<void> retryToSendMessage(int index, Message message) async {
    _messages.removeAt(index);
    await sendMessage(message.messageBody);
  }

  Message? getMessageWithIndex(int index) {
    if (hasMessage()) {
      return _messages[index];
    } else {
      return null;
    }
  }

  String getMessageDateText(BuildContext context, int index) {
    return '${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(getMessageWithIndex(index)?.dateOfCreated ?? DateTime(2000))},' +
        ' ${DateFormat.Hm(Localizations.localeOf(context).languageCode).format(getMessageWithIndex(index)?.dateOfCreated ?? DateTime(2000))}';
  }

  /*String date =
        '${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(message.dateOfCreated)},'
        ' ${DateFormat.Hm(Localizations.localeOf(context).languageCode).format(message.dateOfCreated)}';
    if (isUserSender) {
      //date += '  \u2714';
      //date += '  \u{1f553}';
      //date += '  \u2b94';
    }

    return date;
     */

  int getMessageStatusWithMessageId(String messageId) {
    if (hasMessage()) {
      Message? m = _messages.firstWhereOrNull((m) => m.messageId == messageId);
      if (m != null) {
        return m.status;
      }
    }
    return Message.STATUS_ERROR;
  }

  bool hasMessage() {
    return _messages.length > 0;
  }

  bool isUserSender(int index) {
    bool result = true;
    Message? message = getMessageWithIndex(index);
    if (_currentDatabaseUserId != null) {
      result = message?.senderId == _currentDatabaseUserId;
    }
    return result;
  }

  void _addListener() {
    if (_currentDatabaseUserId != null) {
      _newMessageSubscription = _messagesDatabaseRepository
          .addListenerToMessages(_currentDatabaseUserId!, _contactUser.userId)
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
  }

  updateMessageStatus(Message message, int status) {
    for (Message m in _messages) {
      if (m.randomId == message.randomId) {
        m.status = status;
        notifyListeners();
        return;
      }
    }
  }

  newMessageHandler(Message newMessage) {
    for (Message m in _messages) {
      if (m.randomId == newMessage.randomId) {
        m.messageId = newMessage.messageId;
        m.status = newMessage.status;
        m.dateOfCreated = newMessage.dateOfCreated;
        notifyListeners();
        return;
      }
    }
    _messages.insert(0, newMessage);
    notifyListeners();
  }

  bool isMessageAlreadyInList(Message message) {
    for (Message m in _messages) {
      if (m.randomId == message.randomId) return true;
    }
    return false;
  }
}
