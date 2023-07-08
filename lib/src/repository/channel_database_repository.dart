import 'package:c_messaging/src/base/channel_database_base.dart';
import 'package:c_messaging/src/service/base/channel_database_service.dart';
import 'package:c_messaging/src/service/firebase/firestore_channel_database_service.dart';
import 'package:c_messaging/src/tools/locator.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/settings/service_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

class ChannelDatabaseRepository implements ChannelDatabaseBase {
  ChannelDatabaseService _service = locator<FirestoreChannelDatabaseService>();

  @override
  void initialize(SettingsBase settings) {
    if (settings is ServiceSettings) {
      if (settings.channelDatabaseServiceMode ==
          ChannelDatabaseServiceMode.Firestore) {
        _service = locator<FirestoreChannelDatabaseService>();
      } else {
        //_service = locator<DebugChannelDatabaseService>();
      }
    }
  }

  @override
  Future<List> getChannels(lastItemToStartAfter, int paginationLimit) async {
    return await _service.getChannels(lastItemToStartAfter, paginationLimit);
  }
}
