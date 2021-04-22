import 'package:c_messaging/src/base/custom_user_database_base.dart';
import 'package:c_messaging/src/helper/locator.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/model/custom_user.dart';
import 'package:c_messaging/src/service/base/custom_user_database_service.dart';
import 'package:c_messaging/src/service/custom_user_database_service_debug.dart';
import 'package:c_messaging/src/service/custom_user_database_service_firestore.dart';
import 'package:c_messaging/src/settings/service_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

class CustomUserDatabaseRepository implements CustomUserDatabaseBase {
  late CustomUserDatabaseService _service;

  @override
  void initialize(SettingsBase settings) {
    if (settings is ServiceSettings) {
      if (settings.userDatabaseServiceMode ==
          UserDatabaseServiceMode.Firestore) {
        _service = locator<FirestoreCustomUserDatabaseService>();
      } else {
        _service = locator<DebugCustomUserDatabaseService>();
      }
    }
  }

  @override
  Future<CustomUser?> getUser(dynamic userId) async {
    return await _service.getUser(userId);
  }
}
