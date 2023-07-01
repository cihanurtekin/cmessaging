import 'package:c_messaging/src/model/user.dart';
import 'package:flutter/material.dart';

enum MessageFileStatus { Loading, Loaded, Error }

class Message with ChangeNotifier {
  static const String messageIdKey = 'messageId';
  static const String contactIdKey = 'contactId';
  static const String senderIdKey = 'senderId';
  static const String receiverIdKey = 'receiverId';
  static const String messageBodyKey = 'messageBody';
  static const String dateOfCreatedKey = 'dateOfCreated';
  static const String statusKey = 'status';
  static const String sendStatusKey = 'sendStatus';
  static const String messageTypeKey = 'messageType';

  //static const String randomIdKey = 'randomId';

  String messageId;
  String contactId;
  String senderId;
  String receiverId;
  String messageBody;
  DateTime dateOfCreated;
  int status;
  int sendStatus;
  int messageType;

  //String randomId = Uuid().v4();

  User? contactUser;

  Message({
    required this.messageId,
    this.contactId = '',
    required this.senderId,
    required this.receiverId,
    required this.messageBody,
    required this.dateOfCreated,
    this.status = MessageStatus.active,
    this.sendStatus = MessageSendStatus.waiting,
    this.messageType = MessageType.text,
  });

  Map<String, dynamic> toMap(
      {bool convertDateToMicrosecondsSinceEpoch = false}) {
    return {
      messageIdKey: messageId,
      contactIdKey: contactId,
      senderIdKey: senderId,
      receiverIdKey: receiverId,
      messageBodyKey: messageBody,
      dateOfCreatedKey: convertDateToMicrosecondsSinceEpoch
          ? dateOfCreated.microsecondsSinceEpoch
          : dateOfCreated,
      statusKey: status,
      sendStatusKey: sendStatus,
      messageTypeKey: messageType,
    };
  }

  Message.fromMap(this.messageId, Map<String, dynamic> map)
      : contactId = map[contactIdKey] ?? '',
        senderId = map[senderIdKey] ?? '',
        receiverId = map[receiverIdKey] ?? '',
        messageBody = map[messageBodyKey] ?? '',
        dateOfCreated = map[dateOfCreatedKey],
        status = map[statusKey] ?? MessageStatus.active,
        sendStatus = map[sendStatusKey] ?? MessageSendStatus.waiting,
        messageType = map[messageTypeKey] ?? MessageType.text;

  void updateSendStatus(int newSendStatus) async {
    sendStatus = newSendStatus;
    notifyListeners();
  }

  void update(Map<String, dynamic> newValues) {
    if (newValues.containsKey(messageIdKey)) {
      messageId = newValues[messageIdKey];
    }
    if (newValues.containsKey(contactIdKey)) {
      contactId = newValues[contactIdKey];
    }
    if (newValues.containsKey(senderIdKey)) {
      senderId = newValues[senderIdKey];
    }
    if (newValues.containsKey(receiverIdKey)) {
      receiverId = newValues[receiverIdKey];
    }
    if (newValues.containsKey(messageBodyKey)) {
      messageBody = newValues[messageBodyKey];
    }
    if (newValues.containsKey(dateOfCreatedKey)) {
      dateOfCreated = newValues[dateOfCreatedKey];
    }
    if (newValues.containsKey(statusKey)) {
      status = newValues[statusKey];
    }
    if (newValues.containsKey(sendStatusKey)) {
      sendStatus = newValues[sendStatusKey];
    }
    if (newValues.containsKey(messageTypeKey)) {
      messageType = newValues[messageTypeKey];
    }
    notifyListeners();
  }
}

class MessageStatus {
  static const int active = 1;
  static const int deleted = -1;
}

class MessageSendStatus {
  static const int error = -1;
  static const int waiting = 0;
  static const int sent = 1;
  static const int received = 2;
  static const int seen = 3;
}

class MessageType {
  static const int text = 1;
  static const int image = 2;
}
