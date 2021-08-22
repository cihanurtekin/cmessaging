class Notification {
  static const String idKey = 'id';
  static const String titleKey = 'title';
  static const String bodyKey = 'body';
  static const String typeKey = 'notification_type';

  final int id;
  final String? title;
  final String? body;
  final String type;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      idKey: this.id,
      titleKey: this.title,
      bodyKey: this.body,
      typeKey: this.type,
    };
  }
}

class NotificationType {
  static const String MESSAGE = 'message';
}
