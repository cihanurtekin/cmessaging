import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

class ServiceSettings implements SettingsBase {
  final MessageDatabaseServiceMode messagesDatabaseServiceMode;
  final UserDatabaseServiceMode userDatabaseServiceMode;
  final ChannelDatabaseServiceMode channelDatabaseServiceMode;
  final NotificationServiceMode notificationServiceMode;
  final StorageServiceMode storageServiceMode;

  ServiceSettings({
    required this.messagesDatabaseServiceMode,
    required this.userDatabaseServiceMode,
    required this.channelDatabaseServiceMode,
    required this.notificationServiceMode,
    required this.storageServiceMode,
  });
}
