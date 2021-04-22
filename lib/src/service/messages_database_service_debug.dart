import 'package:c_messaging/src/base/messages_database_base.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/service/base/messages_database_service.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

class DebugMessagesDatabaseService implements MessagesDatabaseService {
  @override
  void initialize(SettingsBase settings) {
    // TODO: implement initialize
  }

  @override
  Future<MessagesDatabaseResult> deleteMessage(String currentUserId,
      Message message, bool isLastMessage, Message newLastMessage) {
    // TODO: implement deleteMessage
    return Future.value();
  }

  @override
  Future<Message?> getMessage(String currentUserId, String messageUid) {
    // TODO: implement getMessage
    return Future.value();
  }

  @override
  Future<MessagesDatabaseResult> sendMessage(
      String currentUserId, Message message) {
    // TODO: implement sendMessage
    return Future.value();
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
    return Future.value();
  }

  @override
  Future<MessagesDatabaseResult> deleteAllMessagesOfContact(
      String currentUserId, String contactUid) {
    // TODO: implement deleteAllMessagesOfUser
    return Future.value();
  }

  @override
  Stream<List<Message?>> addListenerToMessages(
      String currentUserId, contactId) {
    return Stream.empty();
  }

  @override
  Stream<List<Message?>> addListenerToContacts(
      String currentUserId, contactId) {
    return Stream.empty();
  }
}
