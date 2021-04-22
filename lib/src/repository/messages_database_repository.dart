import 'package:c_messaging/src/base/messages_database_base.dart';
import 'package:c_messaging/src/helper/locator.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/service/base/messages_database_service.dart';
import 'package:c_messaging/src/service/messages_database_service_debug.dart';
import 'package:c_messaging/src/service/messages_database_service_firestore.dart';
import 'package:c_messaging/src/settings/service_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

class MessagesDatabaseRepository implements MessagesDatabaseBase {
  late MessagesDatabaseService _service;

  @override
  void initialize(SettingsBase settings) {
    if (settings is ServiceSettings) {
      if (settings.userDatabaseServiceMode ==
          UserDatabaseServiceMode.Firestore) {
        _service = locator<FirestoreMessagesDatabaseService>();
      } else {
        _service = locator<DebugMessagesDatabaseService>();
      }
    }
  }

  @override
  Future<MessagesDatabaseResult> deleteMessage(
    String currentUserId,
    Message message,
    bool isLastMessage,
    Message newLastMessage,
  ) async {
    return await _service.deleteMessage(
      currentUserId,
      message,
      isLastMessage,
      newLastMessage,
    );
  }

  @override
  Future<Message?> getMessage(String currentUserId, String messageUid) {
    return _service.getMessage(currentUserId, messageUid);
  }

  @override
  Future<MessagesDatabaseResult> sendMessage(
    String currentUserId,
    Message message,
  ) async {
    Message m = Message.fromMap(
      message.messageId,
      message.toMap(),
    );
    m.status = Message.STATUS_SENT;
    return await _service.sendMessage(currentUserId, m);
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
    messageListAndLastMessage =
        await _service.getMessagesAndLastMessageWithPagination(
      currentUserId,
      contactId,
      listType,
      lastMessageToStartAfter,
      paginationLimit,
    );
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
    String currentUserId,
    String contactUid,
  ) async {
    return await _service.deleteAllMessagesOfContact(
      currentUserId,
      contactUid,
    );
  }

  @override
  Stream<List<Message?>> addListenerToMessages(
    String currentUserId,
    contactId,
  ) {
    return _service.addListenerToMessages(
      currentUserId,
      contactId,
    );
  }

  @override
  Stream<List<Message?>> addListenerToContacts(
    String currentUserId,
    contactId,
  ) {
    return _service.addListenerToContacts(
      currentUserId,
      contactId,
    );
  }
}
