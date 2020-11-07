import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/message.dart';

enum ListType { Messages, Contacts }

abstract class MessagesDatabaseBase {
  Future<MessagesDatabaseResult> sendMessage(String currentUserId, Message message);

  Future<MessagesDatabaseResult> deleteMessage(String currentUserId,
      Message message, bool isLastMessage, Message newLastMessage);

  Future<Message> getMessage(String currentUserId, String messageUid);

  Future<List> getMessagesAndLastMessageWithPagination(
    String currentUserId,
    String contactId,
    ListType listType,
    lastMessageToStartAfter,
    int paginationLimit,
  );

  Stream<List<Message>> addListenerToMessages(String currentUserId, contactId);

  Stream<List<Message>> addListenerToContacts(String currentUserId, contactId);

  Future<MessagesDatabaseResult> deleteAllMessagesOfContact(
      String currentUserId, String contactUid);
}
