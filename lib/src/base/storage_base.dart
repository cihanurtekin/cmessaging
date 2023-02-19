import 'dart:io';

import 'package:c_messaging/src/settings/settings_base.dart';

abstract class StorageBase {
  void initialize(SettingsBase settings);

  Future<String?> uploadFile(
    String userId,
    String fileName,
    String folderName,
    File file,
    String extension,
  );

  Future<String?> uploadImageFile(
    String userId,
    String fileName,
    String folderName,
    File file,
  );

  Future<String?> uploadMessageImage(
    String senderId,
    String receiverId,
    String fileName,
    File imageFile,
  );
}
