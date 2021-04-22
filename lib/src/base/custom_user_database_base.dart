import 'package:c_messaging/src/model/custom_user.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

abstract class CustomUserDatabaseBase {
  void initialize(SettingsBase settings);

  Future<CustomUser?> getUser(dynamic userId);
}
