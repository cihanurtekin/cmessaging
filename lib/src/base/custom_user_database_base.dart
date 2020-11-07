import 'package:c_messaging/src/model/custom_user.dart';

abstract class CustomUserDatabaseBase {
  Future<CustomUser> getUser(dynamic userId);
}
