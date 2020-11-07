import 'package:c_messaging/src/base/messages_database_base.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/service/messages_database_service_debug.dart';
import 'package:c_messaging/src/service/messages_database_service_firestore.dart';
import 'package:flutter/material.dart';

class MessagesDatabaseRepository implements MessagesDatabaseBase {
  MessagesDatabaseServiceMode _databaseServiceMode;
  DebugMessagesDatabaseService _debugMessagesDatabaseService;
  FirestoreMessagesDatabaseService _firestoreMessagesDatabaseService;

  MessagesDatabaseRepository({
    @required MessagesDatabaseServiceMode databaseServiceMode,
    @required DebugMessagesDatabaseService debugMessagesDatabaseService,
    @required FirestoreMessagesDatabaseService firestoreMessagesDatabaseService,
  }) {
    _databaseServiceMode = databaseServiceMode;
    _debugMessagesDatabaseService = debugMessagesDatabaseService;
    _firestoreMessagesDatabaseService = firestoreMessagesDatabaseService;
  }

  @override
  Future<MessagesDatabaseResult> deleteMessage(String currentUserId,
      Message message, bool isLastMessage, Message newLastMessage) async {
    if (_databaseServiceMode == MessagesDatabaseServiceMode.Debug) {
      return await _debugMessagesDatabaseService.deleteMessage(
          currentUserId, message, isLastMessage, newLastMessage);
    } else if (_databaseServiceMode == MessagesDatabaseServiceMode.Firestore) {
      return await _firestoreMessagesDatabaseService.deleteMessage(
          currentUserId, message, isLastMessage, newLastMessage);
    } else {
      return null;
    }
  }

  @override
  Future<Message> getMessage(String currentUserId, String messageUid) {
    // TODO: implement getMessage
    return null;
  }

  @override
  Future<MessagesDatabaseResult> sendMessage(
      String currentUserId, Message message) async {
    Message m = Message.fromMap(message.messageId, message.toMap());
    m.status = Message.STATUS_SENT;
    if (_databaseServiceMode == MessagesDatabaseServiceMode.Debug) {
      return await _debugMessagesDatabaseService.sendMessage(currentUserId, m);
    } else if (_databaseServiceMode == MessagesDatabaseServiceMode.Firestore) {
      return await _firestoreMessagesDatabaseService.sendMessage(
          currentUserId, m);
    } else {
      return null;
    }
  }

  @override
  Future<List> getMessagesAndLastMessageWithPagination(
    String currentUserId,
    String contactId,
    ListType listType,
    lastMessageToStartAfter,
    int paginationLimit,
  ) async {
    List messageListAndLastMessage;
    //List<CMessage> messageList = [];
    if (_databaseServiceMode == MessagesDatabaseServiceMode.Debug) {
      messageListAndLastMessage = await _debugMessagesDatabaseService
          .getMessagesAndLastMessageWithPagination(currentUserId, contactId,
              listType, lastMessageToStartAfter, paginationLimit);
    } else if (_databaseServiceMode == MessagesDatabaseServiceMode.Firestore) {
      messageListAndLastMessage = await _firestoreMessagesDatabaseService
          .getMessagesAndLastMessageWithPagination(currentUserId, contactId,
              listType, lastMessageToStartAfter, paginationLimit);
    } else {
      return [[], null];
    }
    /*
    if (listType == ListType.Contacts) {
      for (Message m in messageListAndLastMessage[0]) {
        await _userDatabaseRepository.getUser(m.contactId).then((user) {
          if (user != null) {
            m.contactUser = user;
          } else {
            print("MessagesDatabaseRepository / getMessagesAndLastMessageWithPagination : User null");
          }
        });
      }
    }
    */
    return messageListAndLastMessage;
  }

  @override
  Future<MessagesDatabaseResult> deleteAllMessagesOfContact(
      String currentUserId, String contactUid) async {
    if (_databaseServiceMode == MessagesDatabaseServiceMode.Debug) {
      return await _debugMessagesDatabaseService.deleteAllMessagesOfContact(
          currentUserId, contactUid);
    } else if (_databaseServiceMode == MessagesDatabaseServiceMode.Firestore) {
      return await _firestoreMessagesDatabaseService.deleteAllMessagesOfContact(
          currentUserId, contactUid);
    } else {
      return null;
    }
  }

  @override
  Stream<List<Message>> addListenerToMessages(String currentUserId, contactId) {
    if (_databaseServiceMode == MessagesDatabaseServiceMode.Debug) {
      return _debugMessagesDatabaseService.addListenerToMessages(
          currentUserId, contactId);
    } else if (_databaseServiceMode == MessagesDatabaseServiceMode.Firestore) {
      return _firestoreMessagesDatabaseService.addListenerToMessages(
          currentUserId, contactId);
    } else {
      return null;
    }
  }

  @override
  Stream<List<Message>> addListenerToContacts(String currentUserId, contactId) {
    if (_databaseServiceMode == MessagesDatabaseServiceMode.Debug) {
      return _debugMessagesDatabaseService.addListenerToContacts(
          currentUserId, contactId);
    } else if (_databaseServiceMode == MessagesDatabaseServiceMode.Firestore) {
      return _firestoreMessagesDatabaseService.addListenerToContacts(
          currentUserId, contactId);
    } else {
      return null;
    }
  }
}
