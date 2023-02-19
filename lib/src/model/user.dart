class User {
  String userId;
  String username;
  String profilePhotoUrl;
  String notificationId;

  User({
    required this.userId,
    required this.username,
    required this.profilePhotoUrl,
    required this.notificationId,
  });

  @override
  String toString() {
    return 'User{userId: $userId, username: $username, profilePhotoUrl: $profilePhotoUrl, notificationId: $notificationId}';
  }
}
