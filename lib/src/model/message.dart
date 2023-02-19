import 'package:c_messaging/src/model/user.dart';
import 'package:uuid/uuid.dart';

enum MessageFileStatus { Loading, Loaded, Error }

class Message {
  static const int STATUS_ERROR = -1;
  static const int STATUS_WAITING = 10;
  static const int STATUS_SENT = 11;
  static const int STATUS_RECEIVED = 12;
  static const int STATUS_SEEN = 13;

  static const int MESSAGE_TYPE_TEXT = 20;
  static const int MESSAGE_TYPE_IMAGE = 21;

  static const String messageIdKey = 'messageId';
  static const String contactIdKey = 'contactId';
  static const String senderIdKey = 'senderId';
  static const String receiverIdKey = 'receiverId';
  static const String messageBodyKey = 'messageBody';
  static const String dateOfCreatedKey = 'dateOfCreated';
  static const String deletedKey = 'deleted';
  static const String statusKey = 'status';
  static const String messageTypeKey = 'messageType';
  static const String randomIdKey = 'randomId';

  late String messageId;
  late String contactId;
  late String senderId;
  late String receiverId;
  late String messageBody;
  late DateTime dateOfCreated;
  late int deleted;
  late int status;
  late int messageType;
  late String randomId = Uuid().v4();

  User? contactUser;

  Message({
    this.messageId = '',
    this.contactId = '',
    this.senderId = '',
    this.receiverId = '',
    this.messageBody = '',
    required this.dateOfCreated,
    this.deleted = 0,
    this.status = STATUS_WAITING,
    this.messageType = MESSAGE_TYPE_TEXT,
    randomIdParam = '',
  }) {
    if (randomIdParam != null && randomIdParam.trim().isNotEmpty) {
      randomId = randomIdParam;
    }
  }

  Map<String, dynamic> toMap(
      {bool convertDateToMicrosecondsSinceEpoch = false}) {
    return {
      messageIdKey: this.messageId,
      contactIdKey: this.contactId,
      senderIdKey: this.senderId,
      receiverIdKey: this.receiverId,
      messageBodyKey: this.messageBody,
      dateOfCreatedKey: convertDateToMicrosecondsSinceEpoch
          ? this.dateOfCreated.microsecondsSinceEpoch
          : this.dateOfCreated,
      deletedKey: this.deleted,
      statusKey: this.status,
      messageTypeKey: this.messageType,
      randomIdKey: this.randomId,
    };
  }

  Message.fromMap(String messageUid, Map<String, dynamic> map,
      {bool getDateFromMicrosecondsSinceEpoch = false}) {
    this.messageId = messageUid;
    this.contactId = map[contactIdKey];
    this.senderId = map[senderIdKey];
    this.receiverId = map[receiverIdKey];
    this.messageBody = map[messageBodyKey];
    this.dateOfCreated = getDateFromMicrosecondsSinceEpoch
        ? DateTime.fromMicrosecondsSinceEpoch(map[dateOfCreatedKey])
        : map[dateOfCreatedKey];
    this.deleted = map[deletedKey];
    this.status = map[statusKey];
    this.messageType = map[messageTypeKey];
    this.randomId = map[randomIdKey];
  }

  static String generateRandomId() {
    return Uuid().v4();
  }

  @override
  String toString() {
    return 'Message{messageId: $messageId, contactId: $contactId, '
        'senderId: $senderId, receiverId: $receiverId, '
        'messageBody: $messageBody, dateOfCreated: $dateOfCreated, '
        'deleted: $deleted, status: $status, messageType: $messageType, '
        'randomId: $randomId, contactUser: $contactUser}';
  }
}
