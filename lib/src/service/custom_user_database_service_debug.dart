import 'package:c_messaging/src/base/custom_user_database_base.dart';
import 'package:c_messaging/src/model/custom_user.dart';

class DebugCustomUserDatabaseService implements CustomUserDatabaseBase {
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
