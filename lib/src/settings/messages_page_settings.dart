import 'package:c_messaging/src/settings/page_settings.dart';
import 'package:c_messaging/src/tools/assets.dart';
import 'package:flutter/material.dart';

class MessagesPageSettings extends PageSettings {
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
  final Color senderMessageBackgroundColor;
  final Color receiverMessageBackgroundColor;
  final Color sendMessageButtonColor;

  MessagesPageSettings({
    super.paginationLimitForFirstQuery,
    super.paginationLimitForOtherQueries,
    super.buildScaffold,
    super.showAppBar,
    super.profilePhotoBackgroundColor,
    super.appBarColor,
    super.backIconColor,
    super.titleTextColor,
    super.backgroundColor,
    super.appBar,
    super.noMessageWidget,
    this.backgroundImageAssetPath,
    this.messagePhotoPlaceholderPath = Assets.messagePhotoPlaceholder,
    this.profilePhotoPlaceholderPath = Assets.noPp,
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
    this.senderMessageBackgroundColor =
        const Color.fromARGB(255, 220, 248, 198),
    this.receiverMessageBackgroundColor = Colors.white,
    this.sendMessageButtonColor = const Color.fromARGB(255, 18, 140, 126),
  });
}
