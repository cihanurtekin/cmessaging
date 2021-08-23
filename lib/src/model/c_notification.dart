class CNotification {
  static const String idKey = 'id';
  static const String titleKey = 'title';
  static const String bodyKey = 'body';
  static const String typeKey = 'notification_type';
  static const String contactUserIdKey = 'contact_user_id';

  final int id;
  final String? title;
  final String? body;
  final String? type;
  final String? contactUserId;

  CNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.contactUserId,
  });

  Map<String, dynamic> toMap() {
    return {
      idKey: this.id,
      titleKey: this.title,
      bodyKey: this.body,
      typeKey: this.type,
      contactUserIdKey: this.contactUserId,
    };
  }
}

/*class CNotificationType {
  static const String MESSAGE = 'message';
}*/
