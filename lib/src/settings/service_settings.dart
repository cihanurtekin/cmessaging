import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

class ServiceSettings implements SettingsBase {
  final MessagesDatabaseServiceMode messagesDatabaseServiceMode;
  final UserDatabaseServiceMode userDatabaseServiceMode;
  final NotificationServiceMode notificationServiceMode;

  ServiceSettings({
    required this.messagesDatabaseServiceMode,
    required this.userDatabaseServiceMode,
    required this.notificationServiceMode,
  });
}
