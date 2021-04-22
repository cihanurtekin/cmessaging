import 'package:c_messaging/src/base/messages_database_base.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/service/base/messages_database_service.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMessagesDatabaseService implements MessagesDatabaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late FirebaseSettings _firebaseSettings;

  @override
  void initialize(SettingsBase settings) {
    if (settings is FirebaseSettings) {
      _firebaseSettings = settings;
      _firestore.settings = Settings(
        persistenceEnabled: settings.firestorePersistenceEnabledMessages,
      );
    }
  }

  @override
  Future<MessagesDatabaseResult> deleteMessage(String currentUserId,
      Message message, bool isLastMessage, Message newLastMessage) async {
    MessagesDatabaseResult result = MessagesDatabaseResult.Success;

    String contactUid = currentUserId == message.senderId
        ? message.receiverId
        : message.senderId;

    WriteBatch deleteBatch = _firestore.batch();

    DocumentReference docRefMessage =
        _getFirestoreContactDocument(currentUserId, contactUid)
            .collection(_firebaseSettings.messagesOfUserCollectionName)
            .doc(message.messageId);

    //deleteBatch.delete(docRefMessage);
    deleteBatch.set(docRefMessage, {Message.deletedKey: 1});

    if (isLastMessage) {
      DocumentReference docRefLastMessage =
          _getFirestoreContactDocument(currentUserId, contactUid);

      deleteBatch.set(docRefLastMessage, newLastMessage.toMap());
    }

    await deleteBatch.commit().catchError((e) {
      result = MessagesDatabaseResult.Error;
      print(
          "FirestoreMessagesDatabaseService / deleteMessage : " + e.toString());
    });

    return result;
  }

  @override
  Future<Message?> getMessage(String currentUserId, String messageUid) {
    // TODO: implement getMessage
    return Future.value();
  }

  @override
  Future<MessagesDatabaseResult> sendMessage(
      String currentUserId, Message message) async {
    MessagesDatabaseResult result = MessagesDatabaseResult.Error;

    message.contactId = message.receiverId;
    Map<String, dynamic> messageMapDocRefSender = message.toMap();
    message.contactId = message.senderId;
    Map<String, dynamic> messageMapDocRefReceiver = message.toMap();

    messageMapDocRefSender[Message.dateOfCreatedKey] =
        FieldValue.serverTimestamp();
    messageMapDocRefReceiver[Message.dateOfCreatedKey] =
        FieldValue.serverTimestamp();

    DocumentReference docRefSender =
        _getFirestoreContactDocument(message.senderId, message.receiverId);
    DocumentReference docRefReceiver =
        _getFirestoreContactDocument(message.receiverId, message.senderId);
    DocumentReference docRefSenderMessages = docRefSender
        .collection(_firebaseSettings.messagesOfUserCollectionName)
        .doc();
    DocumentReference docRefReceiverMessages = docRefReceiver
        .collection(_firebaseSettings.messagesOfUserCollectionName)
        .doc();

    await _firestore.runTransaction((transaction) {
      return transaction.get(docRefSender).then((snapshot) {
        transaction.set(docRefSender, messageMapDocRefSender);
        transaction.set(docRefSenderMessages, messageMapDocRefSender);
        transaction.set(docRefReceiver, messageMapDocRefReceiver);
        transaction.set(docRefReceiverMessages, messageMapDocRefReceiver);
      });
    }, timeout: const Duration(seconds: 5)).then((_) {
      result = MessagesDatabaseResult.Success;
    }).catchError((e) {
      result = MessagesDatabaseResult.Error;
      print("FirestoreMessagesDatabaseService / sendMessage : ${e.toString()}");
    });

    /*
    WriteBatch batch = _getWriteBatch(message);

    await batch.commit().then((_) {
      result = MessagesBaseResult.Success;

    }).catchError((e) {
      result = MessagesBaseResult.Error;
      print("FirestoreMessagesDatabaseService / sendMessage : ${e.toString()}");
    });
     */

    return result;
  }

  DocumentReference _getFirestoreContactDocument(String uid1, String uid2) {
    return _firestore
        .collection(_firebaseSettings.messagesCollectionName)
        .doc(uid1)
        .collection(_firebaseSettings.contactsCollectionName)
        .doc(uid2);
  }

  /*
  WriteBatch _getWriteBatch(Message message) {
    message.contactId = message.receiverId;
    Map<String, dynamic> messageMapDocRefSender = message.toMap();
    message.contactId = message.senderId;
    Map<String, dynamic> messageMapDocRefReceiver = message.toMap();

    messageMapDocRefSender[Message.DATE_OF_CREATED_FIELD_NAME] =
        FieldValue.serverTimestamp() ?? "";
    messageMapDocRefReceiver[Message.DATE_OF_CREATED_FIELD_NAME] =
        FieldValue.serverTimestamp() ?? "";

    DocumentReference docRefSender =
        _getFirestoreContactDocument(message.senderId, message.receiverId);
    DocumentReference docRefReceiver =
        _getFirestoreContactDocument(message.receiverId, message.senderId);
    DocumentReference docRefSenderMessages =
        docRefSender.collection(messagesOfUserCollectionName).document();
    DocumentReference docRefReceiverMessages =
        docRefReceiver.collection(messagesOfUserCollectionName).document();

    WriteBatch batch = _firestore.batch();

    batch.setData(docRefSender, messageMapDocRefSender);
    batch.setData(docRefSenderMessages, messageMapDocRefSender);
    batch.setData(docRefReceiver, messageMapDocRefReceiver);
    batch.setData(docRefReceiverMessages, messageMapDocRefReceiver);

    return batch;
  }
   */

  @override
  Future<List> getMessagesAndLastMessageWithPagination(
    String currentUserId,
    String contactId,
    ListType listType,
    lastMessageToStartAfter,
    int paginationLimit,
  ) async {
    DocumentSnapshot? lastMessageDocument;
    if (lastMessageToStartAfter != null) {
      try {
        lastMessageDocument = lastMessageToStartAfter as DocumentSnapshot;
      } catch (e) {
        return [];
      }
    }

    List<Message> messages = [];
    //int paginationLimit = paginationLimitContacts;

    CollectionReference colRef = _firestore
        .collection(_firebaseSettings.messagesCollectionName)
        .doc(currentUserId)
        .collection(_firebaseSettings.contactsCollectionName);

    if (listType == ListType.Messages) {
      colRef = colRef
          .doc(contactId)
          .collection(_firebaseSettings.messagesOfUserCollectionName);
      //paginationLimit = paginationLimitMessages;
    }

    Query query = colRef
        .where(Message.deletedKey, isEqualTo: 0)
        .orderBy(Message.dateOfCreatedKey, descending: true)
        .limit(paginationLimit);

    if (lastMessageDocument != null) {
      query = query.startAfterDocument(lastMessageDocument);
    }

    QuerySnapshot qs = await query.get();

    if (qs.docs.length > 0) {
      for (DocumentSnapshot doc in qs.docs) {
        try {
          Message? m = getMessageFromDocumentSnapshot(doc);
          if (m != null) {
            messages.add(m);
          }
        } catch (e) {
          print("FirestoreMessagesDatabaseService / "
              "getMessagesAndLastMessageWithPagination : "
              "${e.toString()}");
          //messages = [];
          //break;
        }
      }
      lastMessageDocument = qs.docs.last;
    }
    return [List<Message>.from(messages), lastMessageDocument];
  }

  Message? getMessageFromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic>? messageMap = doc.data();
    if (messageMap != null) {
      messageMap[Message.dateOfCreatedKey] = doc.metadata.hasPendingWrites
          ? DateTime.now()
          : messageMap[Message.dateOfCreatedKey] =
              (messageMap[Message.dateOfCreatedKey] as Timestamp).toDate();

      Message m = Message.fromMap(doc.id, messageMap);
      return m;
    }
    return null;
  }

  @override
  Future<MessagesDatabaseResult> deleteAllMessagesOfContact(
      String currentUserId, String contactUid) async {
    MessagesDatabaseResult result = MessagesDatabaseResult.Success;

    await _getFirestoreContactDocument(currentUserId, contactUid)
        .delete()
        .then((_) {
      return _deleteAllMessagesOfUserCollection(currentUserId, contactUid);
    }).catchError((e) {
      result = MessagesDatabaseResult.Error;
      print(
          "FirestoreMessagesDatabaseService / deleteAllMessagesOfContact : ${e.toString()}");
    });

    return result;
  }

  Future<void> _deleteAllMessagesOfUserCollection(
      String userUid, String contactUid) async {
    await _getFirestoreContactDocument(userUid, contactUid)
        .collection(_firebaseSettings.messagesOfUserCollectionName)
        .where(Message.deletedKey, isEqualTo: 0)
        .orderBy(Message.dateOfCreatedKey, descending: false)
        .get()
        .then((snap) {
      for (DocumentSnapshot ds in snap.docs) {
        try {
          ds.reference.set({Message.deletedKey: 1});
        } catch (e) {
          print(
              "FirestoreMessagesDatabaseService / _deleteAllMessagesOfUserCollection : ${e.toString()}");
        }
      }
    });
  }

  @override
  Stream<List<Message?>> addListenerToMessages(
      String currentUserId, contactId) {
    Stream<QuerySnapshot> qsStream =
        _getFirestoreContactDocument(currentUserId, contactId)
            .collection(_firebaseSettings.messagesOfUserCollectionName)
            .where(Message.deletedKey, isEqualTo: 0)
            .orderBy(Message.dateOfCreatedKey, descending: true)
            .limit(1)
            .snapshots();

    return qsStream.map(
      (querySnapshot) {
        return querySnapshot.docs.map(
          (DocumentSnapshot doc) {
            return !doc.metadata.hasPendingWrites
                ? getMessageFromDocumentSnapshot(doc)
                : null;
          },
        ).toList();
      },
    );
  }

  @override
  Stream<List<Message?>> addListenerToContacts(
      String currentUserId, contactId) {
    Stream<QuerySnapshot> qsStream = _firestore
        .collection(_firebaseSettings.messagesCollectionName)
        .doc(currentUserId)
        .collection(_firebaseSettings.contactsCollectionName)
        .where(Message.deletedKey, isEqualTo: 0)
        .orderBy(Message.dateOfCreatedKey, descending: true)
        .snapshots();

    return qsStream.map(
      (querySnapshot) {
        return querySnapshot.docChanges.map(
          (DocumentChange change) {
            DocumentSnapshot doc = change.doc;
            return !doc.metadata.hasPendingWrites
                ? getMessageFromDocumentSnapshot(doc)
                : null;
          },
        ).toList();
      },
    );
  }
}
