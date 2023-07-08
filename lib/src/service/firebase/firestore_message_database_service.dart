import 'package:c_messaging/src/base/message_database_base.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/model/user.dart';
import 'package:c_messaging/src/repository/user_database_repository.dart';
import 'package:c_messaging/src/service/base/message_database_service.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';
import 'package:c_messaging/src/tools/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreMessageDatabaseService implements MessageDatabaseService {
  final UserDatabaseRepository _userDatabaseRepository =
      locator<UserDatabaseRepository>();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseSettings? _firebaseSettings;

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
  Future<MessageDatabaseResult> sendMessage(
    String currentUserId,
    Message message,
  ) async {
    MessageDatabaseResult result = MessageDatabaseResult.Error;

    if (_firebaseSettings != null) {
      if (message.channelId != null) {
        await _firestore
            .collection(_firebaseSettings!.channelsCollectionName)
            .doc(message.channelId)
            .collection(_firebaseSettings!.messagesOfChannelCollectionName)
            .doc(message.messageId)
            .set(message.toMap());
        result = MessageDatabaseResult.Success;
      } else {
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
            .collection(_firebaseSettings!.messagesOfUserCollectionName)
            .doc(message.messageId);
        DocumentReference docRefReceiverMessages = docRefReceiver
            .collection(_firebaseSettings!.messagesOfUserCollectionName)
            .doc(message.messageId);

        await _firestore.runTransaction((transaction) {
          return transaction.get(docRefSender).then((snapshot) {
            transaction.set(docRefSender, messageMapDocRefSender);
            transaction.set(docRefSenderMessages, messageMapDocRefSender);
            transaction.set(docRefReceiver, messageMapDocRefReceiver);
            transaction.set(docRefReceiverMessages, messageMapDocRefReceiver);
          });
        }, timeout: const Duration(seconds: 5)).then((_) {
          result = MessageDatabaseResult.Success;
        }).catchError((e) {
          result = MessageDatabaseResult.Error;
          debugPrint(
            "FirestoreMessagesDatabaseService / sendMessage : ${e.toString()}",
          );
        });

        /*
    WriteBatch batch = _getWriteBatch(message);

    await batch.commit().then((_) {
      result = MessagesBaseResult.Success;

    }).catchError((e) {
      result = MessagesBaseResult.Error;
      debugPrint("FirestoreMessagesDatabaseService / sendMessage : ${e.toString()}");
    });
     */
      }
    }

    return result;
  }

  @override
  Future<Message?> getMessage(String currentUserId, String messageUid) {
    // TODO: implement getMessage
    return Future.value();
  }

  @override
  Future<List> getMessages(
    String currentUserId,
    String contactId,
    ListType listType,
    lastItemToStartAfter,
    int paginationLimit,
  ) async {
    DocumentSnapshot<Map<String, dynamic>>? lastDocument;
    if (lastItemToStartAfter != null) {
      try {
        lastDocument =
            lastItemToStartAfter as DocumentSnapshot<Map<String, dynamic>>;
      } catch (e) {
        return [];
      }
    }

    List<Message> result = [];

    if (_firebaseSettings != null) {
      CollectionReference<Map<String, dynamic>> colRef = _firestore
          .collection(_firebaseSettings!.messagesCollectionName)
          .doc(currentUserId)
          .collection(_firebaseSettings!.contactsCollectionName);

      if (listType == ListType.messages) {
        colRef = colRef
            .doc(contactId)
            .collection(_firebaseSettings!.messagesOfUserCollectionName);
      }

      if (listType == ListType.channelMessages) {
        colRef = _firestore
            .collection(_firebaseSettings!.channelsCollectionName)
            .doc(contactId)
            .collection(_firebaseSettings!.messagesOfChannelCollectionName);
      }

      Query<Map<String, dynamic>> query = colRef
          .where(Message.statusKey, isEqualTo: MessageStatus.active)
          .orderBy(Message.dateOfCreatedKey, descending: true)
          .limit(paginationLimit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot<Map<String, dynamic>> qs = await query.get();

      if (qs.docs.length > 0) {
        for (DocumentSnapshot<Map<String, dynamic>> doc in qs.docs) {
          try {
            Message? m = getMessageFromDocumentSnapshot(doc);
            if (m != null) {
              if (listType == ListType.contacts) {
                User? user = await _userDatabaseRepository.getUser(
                  m.contactId,
                );
                m.contactUser = user;
              }
              result.add(m);
            }
          } catch (e) {
            debugPrint(
              'FirestoreMessagesDatabaseService / getMessages : '
              '${e.toString()}',
            );
            //messages = [];
            //break;
          }
        }
        lastDocument = qs.docs.last;
      }
    }
    return [List<Message>.from(result), lastDocument];
  }

  Message? getMessageFromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic>? messageMap = doc.data();
    if (messageMap != null) {
      messageMap[Message.dateOfCreatedKey] = doc.metadata.hasPendingWrites
          ? DateTime.now()
          : (messageMap[Message.dateOfCreatedKey] as Timestamp).toDate();

      Message m = Message.fromMap(doc.id, messageMap);
      return m;
    }
    return null;
  }

  @override
  Future<MessageDatabaseResult> deleteMessage(
    String currentUserId,
    Message message,
    bool isLastMessage,
    Message newLastMessage,
  ) async {
    MessageDatabaseResult result = MessageDatabaseResult.Success;

    if (_firebaseSettings != null) {
      String contactUid = currentUserId == message.senderId
          ? message.receiverId
          : message.senderId;

      WriteBatch deleteBatch = _firestore.batch();

      DocumentReference docRefMessage =
          _getFirestoreContactDocument(currentUserId, contactUid)
              .collection(_firebaseSettings!.messagesOfUserCollectionName)
              .doc(message.messageId);

      //deleteBatch.delete(docRefMessage);
      deleteBatch.set(docRefMessage, {
        Message.statusKey: MessageStatus.deleted,
      });

      if (isLastMessage) {
        DocumentReference docRefLastMessage =
            _getFirestoreContactDocument(currentUserId, contactUid);

        deleteBatch.set(docRefLastMessage, newLastMessage.toMap());
      }

      await deleteBatch.commit().catchError((e) {
        result = MessageDatabaseResult.Error;
        debugPrint(
          "FirestoreMessagesDatabaseService / deleteMessage : " + e.toString(),
        );
      });
    }

    return result;
  }

  @override
  Future<MessageDatabaseResult> deleteAllMessagesOfContact(
      String currentUserId, String contactUid) async {
    MessageDatabaseResult result = MessageDatabaseResult.Success;

    await _getFirestoreContactDocument(currentUserId, contactUid)
        .delete()
        .then((_) {
      return _deleteAllMessagesOfUserCollection(currentUserId, contactUid);
    }).catchError((e) {
      result = MessageDatabaseResult.Error;
      debugPrint(
        "FirestoreMessagesDatabaseService / deleteAllMessagesOfContact : "
        "${e.toString()}",
      );
    });

    return result;
  }

  Future<void> _deleteAllMessagesOfUserCollection(
    String userUid,
    String contactUid,
  ) async {
    if (_firebaseSettings != null) {
      await _getFirestoreContactDocument(userUid, contactUid)
          .collection(_firebaseSettings!.messagesOfUserCollectionName)
          .where(Message.statusKey, isEqualTo: MessageStatus.active)
          .orderBy(Message.dateOfCreatedKey, descending: false)
          .get()
          .then((snap) {
        for (DocumentSnapshot ds in snap.docs) {
          try {
            ds.reference.set({Message.statusKey: MessageStatus.deleted});
          } catch (e) {
            debugPrint(
              "FirestoreMessagesDatabaseService / "
              "_deleteAllMessagesOfUserCollection : "
              "${e.toString()}",
            );
          }
        }
      });
    }
  }

  @override
  Stream<List<Message?>> addListenerToContacts(
    String currentUserId,
    contactId,
  ) {
    if (_firebaseSettings != null) {
      Stream<QuerySnapshot<Map<String, dynamic>>> qsStream = _firestore
          .collection(_firebaseSettings!.messagesCollectionName)
          .doc(currentUserId)
          .collection(_firebaseSettings!.contactsCollectionName)
          .where(Message.statusKey, isEqualTo: MessageStatus.active)
          .orderBy(Message.dateOfCreatedKey, descending: true)
          .snapshots();

      return qsStream.map(
        (querySnapshot) {
          return querySnapshot.docChanges.map(
            (DocumentChange<Map<String, dynamic>> change) {
              DocumentSnapshot<Map<String, dynamic>> doc = change.doc;
              return !doc.metadata.hasPendingWrites
                  ? getMessageFromDocumentSnapshot(doc)
                  : null;
            },
          ).toList();
        },
      );
    } else {
      return Stream.empty();
    }
  }

  @override
  Stream<List<Message?>> addListenerToMessages(
    String currentUserId,
    contactId, {
    String? channelId,
  }) {
    if (_firebaseSettings != null) {
      CollectionReference<Map<String, dynamic>> colRef = channelId != null
          ? _firestore
              .collection(_firebaseSettings!.channelsCollectionName)
              .doc(channelId)
              .collection(_firebaseSettings!.messagesOfChannelCollectionName)
          : _getFirestoreContactDocument(currentUserId, contactId)
              .collection(_firebaseSettings!.messagesOfUserCollectionName);

      Stream<QuerySnapshot<Map<String, dynamic>>> qsStream = colRef
          .where(Message.statusKey, isEqualTo: MessageStatus.active)
          .orderBy(Message.dateOfCreatedKey, descending: true)
          .limit(1)
          .snapshots();

      return qsStream.map(
        (querySnapshot) {
          return querySnapshot.docs.map(
            (DocumentSnapshot<Map<String, dynamic>> doc) {
              return getMessageFromDocumentSnapshot(doc);
            },
          ).toList();
        },
      );
    } else {
      return Stream.empty();
    }
  }

  DocumentReference _getFirestoreContactDocument(String uid1, String uid2) {
    // TODO: Ensure '_firebaseSettings' is not null.
    return _firestore
        .collection(_firebaseSettings!.messagesCollectionName)
        .doc(uid1)
        .collection(_firebaseSettings!.contactsCollectionName)
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
}
