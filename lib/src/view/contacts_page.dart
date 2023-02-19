import 'package:c_messaging/src/custom_widgets/no_message_background.dart';
import 'package:c_messaging/src/custom_widgets/profile_photo.dart';
import 'package:c_messaging/src/custom_widgets/shimmer.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/settings/contacts_page_settings.dart';
import 'package:c_messaging/src/settings/language_settings.dart';
import 'package:c_messaging/src/view_model/contacts_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class MessageContactsPage extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final ContactsPageSettings _pageSettings;

  final LanguageSettings _languageSettings;

  MessageContactsPage(this._pageSettings, this._languageSettings) {
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    _addScrollListener(context);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: _pageSettings.backIconColor,
        ),
        onPressed: () {
          ContactsViewModel viewModel =
              Provider.of<ContactsViewModel>(context, listen: false);
          viewModel.onBackButtonPressed(context);
        },
      ),
      title: Text(
        _languageSettings.contactsPageTitle,
        style: TextStyle(
          color: _pageSettings.titleTextColor,
        ),
      ),
      backgroundColor: _pageSettings.toolbarColor,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<ContactsViewModel>(builder: (context, viewModel, child) {
      if (viewModel.state == ContactsViewState.Idle && viewModel.hasMessage()) {
        return _buildListView(context);
      } else if (viewModel.state == ContactsViewState.Idle &&
          !viewModel.hasMessage()) {
        return _buildNoMessageBody();
      } else if (viewModel.state == ContactsViewState.Error) {
        return _buildErrorBody(context);
      } else {
        return _buildShimmer();
      }
    });
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
          child: _buildListTileView(context, index, true),
        );
      },
    );
  }

  Widget _buildListView(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        ContactsViewModel viewModel =
            Provider.of<ContactsViewModel>(context, listen: false);
        viewModel.refreshContacts();
      },
      child: Consumer<ContactsViewModel>(
        builder: (context, viewModel, child) => ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _controller,
          itemCount: viewModel.messages.length,
          itemBuilder: _buildListTile,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, int index) {
    return _buildListTileView(context, index, false);
  }

  Widget _buildListTileView(BuildContext context, int index, bool isShimmer) {
    ContactsViewModel viewModel =
        Provider.of<ContactsViewModel>(context, listen: false);
    Message? message = viewModel.getMessageWithIndex(index);
    return message != null
        ? InkWell(
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
                                : message.contactUser?.profilePhotoUrl ?? "",
                            placeholderImagePath:
                                _pageSettings.profilePhotoPlaceholderPath,
                            radius: _pageSettings.profilePhotoRadius,
                            backgroundColor:
                                _pageSettings.profilePhotoBackgroundColor,
                          ),
                        SizedBox(
                            width:
                                _pageSettings.profilePhotoAndTextsSpaceBetween),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: isShimmer
                                        ? _shimmerContainer(
                                            128.0, 8.0, 32.0, Colors.grey[400]!)
                                        : Text(
                                            message.contactUser?.username
                                                    .trim() ??
                                                _languageSettings
                                                    .contactsPageDefaultUsername,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: _pageSettings
                                                  .usernameFontSize,
                                              color: _pageSettings
                                                  .usernameTextColor,
                                            ),
                                          ),
                                  ),
                                  isShimmer
                                      ? _shimmerContainer(
                                          64.0, 8.0, 32.0, Colors.grey[400]!)
                                      : Text(
                                          viewModel.getMessageDateText(
                                            context,
                                            index,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: _pageSettings
                                                .messageDateFontSize,
                                            color: _pageSettings
                                                .messageDateTextColor,
                                          ),
                                        ),
                                ],
                              ),
                              isShimmer
                                  ? _shimmerContainer(double.infinity, 8.0,
                                      32.0, Colors.grey[400]!)
                                  : _buildLastMessageRow(context, message),
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
              viewModel.openMessagesPage(context, index);
            },
            //onLongPress: () => _onListTileLongPressed(context, index),
          )
        : Container();
  }

  Widget _buildLastMessageRow(BuildContext context, Message message) {
    ContactsViewModel viewModel =
        Provider.of<ContactsViewModel>(context, listen: false);
    return Row(
      children: <Widget>[
        if (viewModel.isUserSender(message))
          Container(
            margin: EdgeInsets.only(right: 2.0),
            child: Icon(
              message.status == Message.STATUS_WAITING
                  ? Icons.access_time
                  : message.status == Message.STATUS_SENT
                      ? Icons.check
                      : message.status == Message.STATUS_ERROR
                          ? Icons.clear
                          : Icons.access_time,
              size: _pageSettings.lastMessageFontSize,
              color: _pageSettings.lastMessageTextColor,
            ),
          ),
        Expanded(
          child: Text(
            message.messageType == Message.MESSAGE_TYPE_IMAGE
                ? _languageSettings.contactsPageImageTypeText
                : message.messageBody,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: _pageSettings.lastMessageFontSize,
              color: _pageSettings.lastMessageTextColor,
              fontStyle: message.messageType == Message.MESSAGE_TYPE_IMAGE
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
          ),
        ),
      ],
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

  _addScrollListener(BuildContext context) {
    _controller.addListener(() {
      _scrollListener(context);
    });
  }

  _scrollListener(BuildContext context) {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      //if (mounted) {
      Provider.of<ContactsViewModel>(context, listen: false)
          .getMessagesWithPagination();
      //}
    }
  }
}
