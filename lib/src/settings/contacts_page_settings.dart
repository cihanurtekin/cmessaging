import 'package:flutter/material.dart';

class ContactsPageSettings {
  final int paginationLimitForFirstQuery;
  final int paginationLimitForOtherQueries;
  final String defaultUsername;
  final Color? toolbarColor;
  final Color? backIconColor;
  final Color? titleTextColor;
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
  final Color profilePhotoBackgroundColor;
  final Color usernameTextColor;
  final Color lastMessageTextColor;
  final Color messageDateTextColor;
  final String profilePhotoPlaceholderPath;
  final String noMessageAssetImagePath;
  final String noMessageTextContent;
  final double noMessageImageWidth;
  final double noMessageTextSize;
  final double errorMessageTextSize;
  final String imageTypeText;
  final String contactsPageTitle;
  final String errorTryAgainMessage;

  ContactsPageSettings({
    this.paginationLimitForFirstQuery = 10,
    this.paginationLimitForOtherQueries = 10,
    this.defaultUsername = 'Unknown',
    this.toolbarColor,
    this.backIconColor,
    this.titleTextColor,
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
    this.profilePhotoBackgroundColor = Colors.white,
    this.usernameTextColor = Colors.black,
    this.lastMessageTextColor = Colors.grey,
    this.messageDateTextColor = Colors.grey,
    this.profilePhotoPlaceholderPath = 'assets/images/cmessaging/nopp.png',
    this.noMessageAssetImagePath = 'assets/images/cmessaging/nomessage.png',
    this.noMessageTextContent = 'You have no message',
    this.noMessageImageWidth = 300.0,
    this.noMessageTextSize = 30.0,
    this.errorMessageTextSize = 30.0,
    this.imageTypeText = 'Image',
    this.contactsPageTitle = "Contacts",
    this.errorTryAgainMessage = "An error occured, please try again later",
  });
}
