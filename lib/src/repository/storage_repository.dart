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
      if (settings.userDatabaseServiceMode ==
          StorageServiceMode.FirebaseStorage) {
        _service = locator<FirebaseStorageService>();
      } else {
        //_service = locator<DebugStorageService>();
      }
    }
  }

  @override
  Future<String?> uploadFile(
    String userId,
    String fileName,
    String folderName,
    File file,
    String extension,
  ) async {
    return await _service.uploadFile(
      userId,
      fileName,
      folderName,
      file,
      extension,
    );
  }

  @override
  Future<String?> uploadImageFile(
    String userId,
    String fileName,
    String folderName,
    File file,
  ) async {
    return await _service.uploadImageFile(userId, fileName, folderName, file);
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
}
