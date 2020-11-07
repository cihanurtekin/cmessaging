import 'package:c_messaging/src/main/public_enums.dart';
import 'package:flutter/material.dart';

class ServiceSettings {
  final MessagesDatabaseServiceMode messagesDatabaseServiceMode;
  final UserDatabaseServiceMode userDatabaseServiceMode;
  final NotificationServiceMode notificationServiceMode;

  ServiceSettings({
    @required this.messagesDatabaseServiceMode,
    @required this.userDatabaseServiceMode,
    @required this.notificationServiceMode,
  });
}
