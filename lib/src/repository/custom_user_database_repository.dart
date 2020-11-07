import 'package:c_messaging/src/base/custom_user_database_base.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/custom_user.dart';
import 'package:c_messaging/src/service/custom_user_database_service_debug.dart';
import 'package:c_messaging/src/service/custom_user_database_service_firestore.dart';
import 'package:flutter/material.dart';

class CustomUserDatabaseRepository implements CustomUserDatabaseBase {
  UserDatabaseServiceMode _databaseServiceMode;
  DebugCustomUserDatabaseService _debugCustomUserDatabaseService;
  FirestoreCustomUserDatabaseService _firestoreCustomUserDatabaseService;

  CustomUserDatabaseRepository({
    @required UserDatabaseServiceMode databaseServiceMode,
    @required DebugCustomUserDatabaseService debugCustomUserDatabaseService,
    @required
        FirestoreCustomUserDatabaseService firestoreCustomUserDatabaseService,
  }) {
    _databaseServiceMode = databaseServiceMode;
    _debugCustomUserDatabaseService = debugCustomUserDatabaseService;
    _firestoreCustomUserDatabaseService = firestoreCustomUserDatabaseService;
  }

  @override
  Future<CustomUser> getUser(dynamic userId) async {
    if (_databaseServiceMode == UserDatabaseServiceMode.Debug) {
      return await _debugCustomUserDatabaseService.getUser(userId);
    } else if (_databaseServiceMode == UserDatabaseServiceMode.Firestore) {
      return await _firestoreCustomUserDatabaseService.getUser(userId);
    } else {
      return null;
    }
  }
}
