import 'package:c_messaging/src/base/message_database_base.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/service/base/message_database_service.dart';
import 'package:c_messaging/src/settings/debug_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

class DebugMessageDatabaseService implements MessageDatabaseService {
  @override
  void initialize(SettingsBase settings) {
    if (settings is DebugSettings) {}
  }

  @override
  Future<MessageDatabaseResult> sendMessage(
    String currentUserId,
    Message message,
  ) async {
    return MessageDatabaseResult.Success;
  }

  @override
  Future<Message?> getMessage(String currentUserId, String messageUid) async {
    Message message = Message(
      dateOfCreated: DateTime.now(),
    );
    return message;
  }

  @override
  Future<List> getMessagesAndLastMessageWithPagination(
    String currentUserId,
    String contactId,
    ListType listType,
    lastMessageToStartAfter,
    int paginationLimit,
  ) async {
    return [];
  }

  @override
  Future<MessageDatabaseResult> deleteMessage(
    String currentUserId,
    Message message,
    bool isLastMessage,
    Message newLastMessage,
  ) async {
    return MessageDatabaseResult.Success;
  }

  @override
  Future<MessageDatabaseResult> deleteAllMessagesOfContact(
    String currentUserId,
    String contactUid,
  ) async {
    return MessageDatabaseResult.Success;
  }

  @override
  Stream<List<Message?>> addListenerToContacts(
    String currentUserId,
    contactId,
  ) async* {}

  @override
  Stream<List<Message?>> addListenerToMessages(
    String currentUserId,
    contactId,
  ) async* {}
}
