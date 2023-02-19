import 'dart:io';

import 'package:c_messaging/src/service/base/storage_service.dart';
import 'package:c_messaging/src/settings/debug_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';

class DebugStorageService implements StorageService {
  @override
  void initialize(SettingsBase settings) {
    if (settings is DebugSettings) {}
  }

  @override
  Future<String?> uploadFile(
    String userId,
    String fileName,
    String folderName,
    File file,
    String extension,
  ) async {
    return '';
  }

  @override
  Future<String?> uploadImageFile(
    String userId,
    String fileName,
    String folderName,
    File file,
  ) async {
    return '';
  }

  @override
  Future<String?> uploadMessageImage(
    String senderId,
    String receiverId,
    String fileName,
    File imageFile,
  ) async {
    return '';
  }
}
