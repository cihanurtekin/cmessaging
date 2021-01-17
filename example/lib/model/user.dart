class User {
  static const String userIdKey = 'userId';
  static const String emailKey = 'email';
  static const String phoneKey = 'phone';
  static const String profilePhotoUrlKey = 'profilePhotoUrl';
  static const String usernameKey = 'username';
  static const String nameSurnameKey = 'nameSurname';
  static const String notificationIdKey = 'notificationId';
  static const String deletedKey = 'deleted';

  String userId;
  String email;
  String phone;
  String profilePhotoUrl;
  String username;
  String nameSurname;
  String notificationId;
  int deleted;

  User(
      this.userId,
      this.email, {
        this.phone = '',
        this.profilePhotoUrl = '',
        this.username = '',
        this.nameSurname = '',
        this.notificationId = '',
        this.deleted = 0,
      });

  Map<String, dynamic> toMap() {
    return {
      userIdKey: this.userId,
      emailKey: this.email,
      phoneKey: this.phone,
      profilePhotoUrlKey: this.profilePhotoUrl,
      usernameKey: this.username,
      nameSurnameKey: this.nameSurname,
      notificationIdKey: this.notificationId,
      deletedKey: this.deleted,
    };
  }

  User.fromMap(String userId, Map<String, dynamic> map) {
    this.userId = userId;
    this.email = map[emailKey];
    this.phone = map[phoneKey];
    this.profilePhotoUrl = map[profilePhotoUrlKey];
    this.username = map[usernameKey];
    this.nameSurname = map[nameSurnameKey];
    this.notificationId = map[notificationIdKey];
    this.deleted = map[deletedKey];
  }
}
