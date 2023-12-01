import 'package:c_messaging/src/settings/page_settings.dart';
import 'package:c_messaging/src/tools/assets.dart';
import 'package:flutter/material.dart';

class ContactsPageSettings extends PageSettings {
  final bool showContactProfilePhoto;
  final bool showDivider;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final double profilePhotoRadius;
  final double profilePhotoAndTextsSpaceBetween;
  final double dividerHeight;
  final double usernameFontSize;
  final double lastMessageFontSize;
  final double messageDateFontSize;
  final Color usernameTextColor;
  final Color lastMessageTextColor;
  final Color messageDateTextColor;
  final String profilePhotoPlaceholderPath;
  final String noMessageAssetImagePath;
  final double noMessageImageWidth;
  final double noMessageTextSize;
  final double errorMessageTextSize;
  final Widget Function(
    String userId,
    String fullName,
    String profilePhotoUrl,
    String notificationId,
  )? createMessagesAppBar;

  ContactsPageSettings({
    super.paginationLimitForFirstQuery,
    super.paginationLimitForOtherQueries,
    super.buildScaffold,
    super.showAppBar,
    super.appBarColor,
    super.backIconColor,
    super.titleTextColor,
    super.profilePhotoBackgroundColor,
    super.backgroundColor,
    super.appBar,
    super.noMessageWidget,
    this.showContactProfilePhoto = true,
    this.showDivider = true,
    this.paddingTop = 8.0,
    this.paddingBottom = 8.0,
    this.paddingLeft = 8.0,
    this.paddingRight = 8.0,
    this.profilePhotoRadius = 48.0,
    this.profilePhotoAndTextsSpaceBetween = 8.0,
    this.dividerHeight = 0.3,
    this.usernameFontSize = 15.0,
    this.lastMessageFontSize = 14.0,
    this.messageDateFontSize = 11.0,
    this.usernameTextColor = Colors.black,
    this.lastMessageTextColor = Colors.grey,
    this.messageDateTextColor = Colors.grey,
    this.profilePhotoPlaceholderPath = Assets.noPp,
    this.noMessageAssetImagePath = Assets.noMessage,
    this.noMessageImageWidth = 300.0,
    this.noMessageTextSize = 30.0,
    this.errorMessageTextSize = 30.0,
    this.createMessagesAppBar,
  });
}
