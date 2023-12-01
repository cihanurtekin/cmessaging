class LanguageSettings {
  final String send;
  final String cancel;
  final String typeMessage;
  final String takePhoto;
  final String chooseFromGallery;
  final String uploadingImage;
  final String contactsPageTitle;
  final String contactsPageDefaultUsername;
  final String contactsPageNoMessageTextContent;
  final String contactsPageImageTypeText;
  final String contactsPageErrorTryAgainMessage;
  final String messagesPageDefaultUsernameForContactTitle;
  final String messagesPageDefaultUsernameForNotification;

  LanguageSettings({
    this.send = "Send",
    this.cancel = "Cancel",
    this.typeMessage = "Type a message",
    this.takePhoto = "Take a photo",
    this.chooseFromGallery = "Choose from gallery",
    this.uploadingImage = "Uploading image...",
    this.contactsPageTitle = "Contacts",
    this.contactsPageDefaultUsername = 'Unknown',
    this.contactsPageNoMessageTextContent = 'You have no message',
    this.contactsPageImageTypeText = 'Image',
    this.contactsPageErrorTryAgainMessage =
        "An error occured, please try again later",
    this.messagesPageDefaultUsernameForContactTitle = 'Unknown',
    this.messagesPageDefaultUsernameForNotification = 'Unknown',
  });
}
