import 'package:flutter/material.dart';

class CustomUser {
  String userId;
  String username;
  String profilePhotoUrl;
  String notificationId;

  CustomUser({
    @required this.userId,
    @required this.username,
    @required this.profilePhotoUrl,
    @required this.notificationId,
  });

  @override
  String toString() {
    return 'CustomUser{userId: $userId, profilePhotoUrl: $profilePhotoUrl, username: $username, notificationId: $notificationId}';
  }
}
