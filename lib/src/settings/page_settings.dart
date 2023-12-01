import 'package:c_messaging/src/tools/assets.dart';
import 'package:flutter/material.dart';

class PageSettings {
  final int paginationLimitForFirstQuery;
  final int paginationLimitForOtherQueries;
  final bool buildScaffold;
  final bool showAppBar;
  final Color? appBarColor;
  final Color? backIconColor;
  final Color? titleTextColor;
  final Color? backgroundColor;
  final Color profilePhotoBackgroundColor;
  final Color usernameTextColor;
  final Color lastMessageTextColor;
  final Color messageDateTextColor;
  final String profilePhotoPlaceholderPath;
  final String noMessageAssetImagePath;
  final double noMessageImageWidth;
  final double noMessageTextSize;
  final double errorMessageTextSize;
  final Widget? appBar;
  final Widget? noMessageWidget;

  PageSettings({
    this.paginationLimitForFirstQuery = 10,
    this.paginationLimitForOtherQueries = 10,
    this.buildScaffold = true,
    this.showAppBar = true,
    this.appBarColor,
    this.backIconColor,
    this.titleTextColor,
    this.backgroundColor,
    this.profilePhotoBackgroundColor = Colors.white,
    this.usernameTextColor = Colors.black,
    this.lastMessageTextColor = Colors.grey,
    this.messageDateTextColor = Colors.grey,
    this.profilePhotoPlaceholderPath = Assets.noPp,
    this.noMessageAssetImagePath = Assets.noMessage,
    this.noMessageImageWidth = 300.0,
    this.noMessageTextSize = 30.0,
    this.errorMessageTextSize = 30.0,
    this.appBar,
    this.noMessageWidget,
  });
}
