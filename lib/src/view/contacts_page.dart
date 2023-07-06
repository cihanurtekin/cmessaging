import 'package:c_messaging/src/custom_widgets/no_message_background.dart';
import 'package:c_messaging/src/custom_widgets/profile_photo.dart';
import 'package:c_messaging/src/custom_widgets/shimmer.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/settings/contacts_page_settings.dart';
import 'package:c_messaging/src/settings/language_settings.dart';
import 'package:c_messaging/src/tools/converter.dart';
import 'package:c_messaging/src/view_model/contacts_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class MessageContactsPage extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final ContactsPageSettings _pageSettings;

  final LanguageSettings _languageSettings;

  MessageContactsPage(this._pageSettings, this._languageSettings) {
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return _pageSettings.buildScaffold
        ? Scaffold(
            appBar: _pageSettings.showAppBar ? _buildAppBar(context) : null,
            body: _buildBody(context),
          )
        : _buildBody(context);
  }

  AppBar _buildAppBar(BuildContext context) {
    ContactsViewModel viewModel = Provider.of<ContactsViewModel>(
      context,
      listen: false,
    );
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: _pageSettings.backIconColor,
        ),
        onPressed: () {
          viewModel.onBackButtonPressed(context);
        },
      ),
      title: Text(
        _languageSettings.contactsPageTitle,
        style: TextStyle(
          color: _pageSettings.titleTextColor,
        ),
      ),
      backgroundColor: _pageSettings.appBarColor,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<ContactsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.state == ContactsViewState.idle) {
          if (viewModel.messages.isNotEmpty) {
            return _buildListView(context);
          } else {
            return _buildNoMessageBody();
          }
        } else if (viewModel.state == ContactsViewState.error) {
          return _buildErrorBody(context);
        } else {
          return _buildShimmer();
        }
      },
    );
  }

  Widget _buildNoMessageBody() {
    return NoMessageBackground(
      assetImagePath: _pageSettings.noMessageAssetImagePath,
      textContent: _languageSettings.contactsPageNoMessageTextContent,
      imageWidth: _pageSettings.noMessageImageWidth,
      textSize: _pageSettings.noMessageTextSize,
    );
  }

  Widget _buildErrorBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            iconSize: 36.0,
            onPressed: () {
              ContactsViewModel viewModel =
                  Provider.of<ContactsViewModel>(context, listen: false);
              viewModel.refreshContacts();
            },
          ),
          SizedBox(height: 18.0),
          Text(
            _languageSettings.contactsPageErrorTryAgainMessage,
            style: TextStyle(fontSize: _pageSettings.errorMessageTextSize),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.white,
          child: _buildListTileView(context, true),
        );
      },
    );
  }

  Widget _buildListView(BuildContext context) {
    return Consumer<ContactsViewModel>(
      builder: (context, viewModel, child) => RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          viewModel.refreshContacts();
        },
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: viewModel.scrollController,
          itemCount: viewModel.messages.length,
          itemBuilder: (BuildContext context, int index) {
            return ChangeNotifierProvider.value(
              value: viewModel.messages[index],
              child: _buildListTile(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context) {
    return _buildListTileView(context, false);
  }

  Widget _buildListTileView(BuildContext context, bool isShimmer) {
    ContactsViewModel viewModel = Provider.of<ContactsViewModel>(
      context,
      listen: false,
    );
    return Consumer<Message?>(
      builder: (context, message, child) => InkWell(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: _pageSettings.paddingTop,
                bottom: _pageSettings.paddingBottom,
                left: _pageSettings.paddingLeft,
                right: _pageSettings.paddingRight,
              ),
              child: Container(
                height: _pageSettings.profilePhotoRadius,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (_pageSettings.showContactProfilePhoto)
                      ProfilePhoto(
                        photo: isShimmer
                            ? ProfilePhoto.SHIMMER_EFFECT
                            : message?.contactUser?.profilePhotoUrl ?? '',
                        placeholderImagePath:
                            _pageSettings.profilePhotoPlaceholderPath,
                        radius: _pageSettings.profilePhotoRadius,
                        backgroundColor:
                            _pageSettings.profilePhotoBackgroundColor,
                      ),
                    SizedBox(
                        width: _pageSettings.profilePhotoAndTextsSpaceBetween),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: isShimmer
                                    ? _shimmerContainer(
                                        128.0, 8.0, 32.0, Colors.grey[400]!)
                                    : Consumer<Message>(
                                        builder: (context, message, child) =>
                                            Text(
                                          message.contactUser?.username
                                                  .trim() ??
                                              _languageSettings
                                                  .contactsPageDefaultUsername,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize:
                                                _pageSettings.usernameFontSize,
                                            color:
                                                _pageSettings.usernameTextColor,
                                          ),
                                        ),
                                      ),
                              ),
                              isShimmer
                                  ? _shimmerContainer(
                                      64.0, 8.0, 32.0, Colors.grey[400]!)
                                  : Consumer<Message>(
                                      builder: (context, message, child) =>
                                          Text(
                                        Converter.contactDateToText(
                                          context,
                                          message.dateOfCreated,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize:
                                              _pageSettings.messageDateFontSize,
                                          color: _pageSettings
                                              .messageDateTextColor,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          isShimmer
                              ? _shimmerContainer(
                                  double.infinity, 8.0, 32.0, Colors.grey[400]!)
                              : _buildLastMessageRow(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_pageSettings.showDivider)
              Padding(
                padding: EdgeInsets.only(
                  left: _pageSettings.showContactProfilePhoto
                      ? _pageSettings.paddingLeft +
                          _pageSettings.profilePhotoRadius +
                          _pageSettings.profilePhotoAndTextsSpaceBetween
                      : _pageSettings.paddingLeft +
                          _pageSettings.profilePhotoAndTextsSpaceBetween,
                  right: _pageSettings.paddingRight,
                ),
                child: Container(
                  width: double.infinity,
                  height: _pageSettings.dividerHeight,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
        onTap: () {
          if (message != null) {
            viewModel.openMessagesPage(context, message);
          }
        },
        //onLongPress: () => _onListTileLongPressed(context, index),
      ),
    );
  }

  Widget _buildLastMessageRow(BuildContext context) {
    ContactsViewModel viewModel = Provider.of<ContactsViewModel>(
      context,
      listen: false,
    );
    return Consumer<Message>(
      builder: (context, message, child) => Row(
        children: <Widget>[
          if (viewModel.isUserSender(message))
            Container(
              margin: EdgeInsets.only(right: 2.0),
              child: Icon(
                message.sendStatus == MessageSendStatus.waiting
                    ? Icons.access_time
                    : message.sendStatus == MessageSendStatus.sent
                        ? Icons.check
                        : message.sendStatus == MessageSendStatus.error
                            ? Icons.clear
                            : Icons.access_time,
                size: _pageSettings.lastMessageFontSize,
                color: _pageSettings.lastMessageTextColor,
              ),
            ),
          Expanded(
            child: Text(
              message.messageType == MessageType.image
                  ? _languageSettings.contactsPageImageTypeText
                  : message.messageBody,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: _pageSettings.lastMessageFontSize,
                color: _pageSettings.lastMessageTextColor,
                fontStyle: message.messageType == MessageType.image
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerContainer(
      double width, double height, double radius, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(radius))),
    );
  }
}
