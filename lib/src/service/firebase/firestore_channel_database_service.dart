import 'package:c_messaging/src/model/channel.dart';
import 'package:c_messaging/src/service/base/channel_database_service.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreChannelDatabaseService implements ChannelDatabaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseSettings? _firebaseSettings;

  @override
  void initialize(SettingsBase settings) {
    if (settings is FirebaseSettings) {
      _firebaseSettings = settings;
      _firestore.settings = Settings(
        persistenceEnabled: settings.firestorePersistenceEnabledChannels,
      );
    }
  }

  @override
  Future<List> getChannels(lastItemToStartAfter, int paginationLimit) async {
    DocumentSnapshot<Map<String, dynamic>>? lastDocument;
    if (lastItemToStartAfter != null) {
      try {
        lastDocument =
            lastItemToStartAfter as DocumentSnapshot<Map<String, dynamic>>;
      } catch (e) {
        return [];
      }
    }

    List<Channel> result = [];

    if (_firebaseSettings != null) {
      CollectionReference<Map<String, dynamic>> colRef =
          _firestore.collection(_firebaseSettings!.channelsCollectionName);

      Query<Map<String, dynamic>> query = colRef
          .where(Channel.statusKey, isEqualTo: ChannelStatus.active)
          .orderBy(Channel.titleKey)
          .limit(paginationLimit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot<Map<String, dynamic>> qs = await query.get();

      if (qs.docs.length > 0) {
        for (DocumentSnapshot<Map<String, dynamic>> doc in qs.docs) {
          try {
            Channel? c = _getChannelFromDocumentSnapshot(doc);
            if (c != null) {
              result.add(c);
            }
          } catch (e) {
            debugPrint(
              'FirestoreChannelDatabaseService / getChannels : ${e.toString()}',
            );
          }
        }
        lastDocument = qs.docs.last;
      }
    }
    return [List<Channel>.from(result), lastDocument];
  }

  Channel? _getChannelFromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    Map<String, dynamic>? channelMap = doc.data();
    if (channelMap != null) {
      if (channelMap[Channel.dateOfCreatedKey] != null) {
        channelMap[Channel.dateOfCreatedKey] =
            (channelMap[Channel.dateOfCreatedKey] as Timestamp).toDate();
      }

      return Channel.fromMap(doc.id, channelMap);
    }
    return null;
  }
}
