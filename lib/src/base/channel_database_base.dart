import 'package:c_messaging/src/settings/settings_base.dart';

abstract class ChannelDatabaseBase {
  void initialize(SettingsBase settings);

  Future<List> getChannels(lastItemToStartAfter, int paginationLimit);
}
