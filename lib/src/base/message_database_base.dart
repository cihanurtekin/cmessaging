import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

enum ListType { Messages, Contacts }

abstract class MessageDatabaseBase {
  void initialize(SettingsBase settings);

  Future<MessageDatabaseResult> sendMessage(
    String currentUserId,
    Message message,
  );

  Future<Message?> getMessage(
    String currentUserId,
    String messageUid,
  );

  Future<List> getMessagesAndLastMessageWithPagination(
    String currentUserId,
    String contactId,
    ListType listType,
    lastMessageToStartAfter,
    int paginationLimit,
  );

  Future<MessageDatabaseResult> deleteMessage(
    String currentUserId,
    Message message,
    bool isLastMessage,
    Message newLastMessage,
  );

  Future<MessageDatabaseResult> deleteAllMessagesOfContact(
    String currentUserId,
    String contactUid,
  );

  Stream<List<Message?>> addListenerToContacts(
    String currentUserId,
    contactId,
  );

  Stream<List<Message?>> addListenerToMessages(
    String currentUserId,
    contactId,
  );
}
