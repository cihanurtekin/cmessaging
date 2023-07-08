import 'dart:io';

import 'package:c_messaging/src/base/storage_base.dart';
import 'package:c_messaging/src/main/public_enums.dart';
import 'package:c_messaging/src/service/base/storage_service.dart';
import 'package:c_messaging/src/service/firebase/firebase_storage_service.dart';
import 'package:c_messaging/src/settings/settings_base.dart';
import 'package:c_messaging/src/settings/service_settings.dart';
import 'package:c_messaging/src/tools/locator.dart';

class StorageRepository implements StorageBase {
  StorageService _service = locator<FirebaseStorageService>();

  @override
  void initialize(SettingsBase settings) {
    if (settings is ServiceSettings) {
      if (settings.storageServiceMode == StorageServiceMode.FirebaseStorage) {
        _service = locator<FirebaseStorageService>();
      } else {
        //_service = locator<DebugStorageService>();
      }
    }
  }

  @override
  Future<String?> uploadFile(
    String fileName,
    String folderName,
    File file,
    String extension,
  ) async {
    return await _service.uploadFile(
      fileName,
      folderName,
      file,
      extension,
    );
  }

  @override
  Future<String?> uploadImageFile(
    String fileName,
    String folderName,
    File file,
  ) async {
    return await _service.uploadImageFile(fileName, folderName, file);
  }

  @override
  Future<String?> uploadMessageImage(
    String senderId,
    String receiverId,
    String fileName,
    File imageFile,
  ) async {
    return await _service.uploadMessageImage(
      senderId,
      receiverId,
      fileName,
      imageFile,
    );
  }

  @override
  Future<String?> uploadChannelMessageImage(
    String senderId,
    String channelId,
    String fileName,
    File imageFile,
  ) async {
    return await _service.uploadChannelMessageImage(
      senderId,
      channelId,
      fileName,
      imageFile,
    );
  }
}
