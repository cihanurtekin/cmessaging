class User {
  static const String userIdKey = 'userId';
  static const String emailKey = 'email';
  static const String profilePhotoUrlKey = 'profilePhotoUrl';
  static const String usernameKey = 'username';
  static const String notificationIdKey = 'notificationId';

  String userId;
  String email;
  String profilePhotoUrl;
  String username;
  String notificationId;

  User(
      this.userId,
      this.email, {
        this.profilePhotoUrl = '',
        this.username = '',
        this.notificationId = '',
      });

  Map<String, dynamic> toMap() {
    return {
      userIdKey: this.userId,
      emailKey: this.email,
      profilePhotoUrlKey: this.profilePhotoUrl,
      usernameKey: this.username,
      notificationIdKey: this.notificationId,
    };
  }

  User.fromMap(String userId, Map<String, dynamic> map) {
    this.userId = userId;
    this.email = map[emailKey];
    this.profilePhotoUrl = map[profilePhotoUrlKey];
    this.username = map[usernameKey];
    this.notificationId = map[notificationIdKey];
  }
}
