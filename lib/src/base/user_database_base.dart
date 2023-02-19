import 'package:c_messaging/src/model/user.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

abstract class UserDatabaseBase {
  void initialize(SettingsBase settings);

  Future<User?> getUser(dynamic userId);
}
