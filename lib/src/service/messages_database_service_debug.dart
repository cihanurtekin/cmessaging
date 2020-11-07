import 'package:c_messaging/src/base/messages_database_base.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/message.dart';

class DebugMessagesDatabaseService implements MessagesDatabaseBase {
  @override
  Future<MessagesDatabaseResult> deleteMessage(String currentUserId,
      Message message, bool isLastMessage, Message newLastMessage) {
    // TODO: implement deleteMessage
    return null;
  }

  @override
  Future<Message> getMessage(String currentUserId, String messageUid) {
    // TODO: implement getMessage
    return null;
  }

  @override
  Future<MessagesDatabaseResult> sendMessage(
      String currentUserId, Message message) {
    // TODO: implement sendMessage
    return null;
  }

  @override
  Future<List> getMessagesAndLastMessageWithPagination(
    String currentUserId,
    String contactId,
    ListType listType,
    lastMessageToStartAfter,
    int paginationLimit,
  ) {
    // TODO: implement getMessages
    return null;
  }

  @override
  Future<MessagesDatabaseResult> deleteAllMessagesOfContact(
      String currentUserId, String contactUid) {
    // TODO: implement deleteAllMessagesOfUser
    return null;
  }

  @override
  Stream<List<Message>> addListenerToMessages(String currentUserId, contactId) {
    return Stream.empty();
  }

  @override
  Stream<List<Message>> addListenerToContacts(String currentUserId, contactId) {
    return Stream.empty();
  }
}
