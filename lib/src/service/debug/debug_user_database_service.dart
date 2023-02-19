import 'package:c_messaging/src/model/user.dart';
import 'package:c_messaging/src/service/base/user_database_service.dart';
import 'package:c_messaging/src/settings/debug_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

class DebugUserDatabaseService implements UserDatabaseService {
  @override
  void initialize(SettingsBase settings) {
    if (settings is DebugSettings) {}
  }

  @override
  Future<User?> getUser(userId) async {
    User testUser = User(
      userId: '',
      username: '',
      profilePhotoUrl: '',
      notificationId: '',
    );
    return testUser;
  }
}
