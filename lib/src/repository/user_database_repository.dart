import 'package:c_messaging/src/base/user_database_base.dart';
import 'package:c_messaging/src/tools/locator.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/user.dart';
import 'package:c_messaging/src/service/base/user_database_service.dart';
import 'package:c_messaging/src/service/firebase/firestore_user_database_service.dart';
import 'package:c_messaging/src/settings/service_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

class UserDatabaseRepository implements UserDatabaseBase {
  UserDatabaseService _service = locator<FirestoreUserDatabaseService>();

  @override
  void initialize(SettingsBase settings) {
    if (settings is ServiceSettings) {
      if (settings.userDatabaseServiceMode ==
          UserDatabaseServiceMode.Firestore) {
        _service = locator<FirestoreUserDatabaseService>();
      } else {
        //_service = locator<DebugUserDatabaseService>();
      }
    }
  }

  @override
  Future<User?> getUser(dynamic userId) async {
    return await _service.getUser(userId);
  }
}
