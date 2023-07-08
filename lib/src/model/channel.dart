import 'package:flutter/material.dart';

class Channel with ChangeNotifier {
  static const String channelIdKey = 'channelId';
  static const String titleKey = 'title';
  static const String descriptionKey = 'description';
  static const String imageUrlKey = 'imageUrl';
  static const String memberCountKey = 'memberCount';
  static const String memberIdsKey = 'memberIds';
  static const String dateOfCreatedKey = 'dateOfCreated';
  static const String statusKey = 'status';

  String channelId;
  String title;
  String description;
  String imageUrl;
  int memberCount;
  List<String> memberIds;
  DateTime dateOfCreated;
  int status;

  Channel.fromMap(this.channelId, Map<String, dynamic> map)
      : title = map[titleKey] ?? '',
        description = map[descriptionKey] ?? '',
        imageUrl = map[imageUrlKey] ?? '',
        memberCount = map[memberCountKey] ?? 0,
        memberIds = map[memberIdsKey] ?? [],
        dateOfCreated = map[dateOfCreatedKey],
        status = ChannelStatus.active;

  void update(Map<String, dynamic> newValues) {
    if (newValues.containsKey(titleKey)) {
      title = newValues[titleKey];
    }
    if (newValues.containsKey(descriptionKey)) {
      description = newValues[descriptionKey];
    }
    if (newValues.containsKey(imageUrlKey)) {
      imageUrl = newValues[imageUrlKey];
    }
    if (newValues.containsKey(memberCountKey)) {
      memberCount = newValues[memberCountKey];
    }
    if (newValues.containsKey(memberIdsKey)) {
      memberIds = newValues[memberIdsKey];
    }
    if (newValues.containsKey(dateOfCreatedKey)) {
      dateOfCreated = newValues[dateOfCreatedKey];
    }
    if (newValues.containsKey(statusKey)) {
      status = newValues[statusKey];
    }
    notifyListeners();
  }
}

class ChannelStatus {
  static const int active = 1;
  static const int deleted = -1;
}
