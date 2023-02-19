import 'package:flutter/material.dart';

class MessagesPageSettings {
  final int paginationLimitForFirstQuery;
  final int paginationLimitForOtherQueries;
  final String? backgroundImageAssetPath;
  final String messagePhotoPlaceholderPath;
  final String profilePhotoPlaceholderPath;
  final double listTileMinPadding;
  final double listTileMaxPadding;
  final double listTileCornerRadius;
  final double messageTextPadding;
  final double messageBodyTextSize;
  final double messageDateTextSize;
  final double messageStatusIconsSize;
  final double messageWritingTextFieldMinHeight;
  final double profilePhotoAndUsernameSpaceBetween;
  final double profilePhotoRadius;
  final Color? backgroundColor;
  final Color profilePhotoBackgroundColor;
  final Color senderMessageBackgroundColor;
  final Color receiverMessageBackgroundColor;
  final Color sendMessageButtonColor;

  MessagesPageSettings({
    this.paginationLimitForFirstQuery = 10,
    this.paginationLimitForOtherQueries = 10,
    this.backgroundImageAssetPath,
    this.messagePhotoPlaceholderPath =
        'assets/images/cmessaging/message_photo_placeholder.png',
    this.profilePhotoPlaceholderPath = 'assets/images/cmessaging/nomessage.png',
    this.listTileMinPadding = 4.0,
    this.listTileMaxPadding = 32.0,
    this.listTileCornerRadius = 4.0,
    this.messageTextPadding = 8.0,
    this.messageBodyTextSize = 15.0,
    this.messageDateTextSize = 11.0,
    this.messageStatusIconsSize = 11.0,
    this.messageWritingTextFieldMinHeight = 48.0,
    this.profilePhotoAndUsernameSpaceBetween = 8.0,
    this.profilePhotoRadius = 36.0,
    this.backgroundColor,
    this.profilePhotoBackgroundColor = Colors.white,
    this.senderMessageBackgroundColor =
        const Color.fromARGB(255, 220, 248, 198),
    this.receiverMessageBackgroundColor = Colors.white,
    this.sendMessageButtonColor = const Color.fromARGB(255, 18, 140, 126),
  });
}
