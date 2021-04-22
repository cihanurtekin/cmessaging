import 'package:c_messaging/src/model/custom_user.dart';
import 'package:c_messaging/src/service/base/custom_user_database_service.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

class DebugCustomUserDatabaseService implements CustomUserDatabaseService {
  @override
  void initialize(SettingsBase settings) {
    // TODO: implement initialize
  }

  @override
  Future<CustomUser> getUser(dynamic userId) async {
    CustomUser testUser = CustomUser(
      userId: '',
      username: '',
      profilePhotoUrl: '',
      notificationId: '',
    );

    return testUser;
  }
}
