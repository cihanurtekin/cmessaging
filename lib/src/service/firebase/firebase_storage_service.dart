import 'dart:io';

import 'package:c_messaging/src/service/base/storage_service.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/settings_base.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseStorageService implements StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseSettings? _firebaseSettings;

  @override
  void initialize(SettingsBase settings) {
    if (settings is FirebaseSettings) {
      _firebaseSettings = settings;
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
    if (_firebaseSettings != null) {
      //String initialFolderName = '${_firebaseSettings!.usersFolderName}/$userId/';
      //String finalFolderName = '$initialFolderName$folderName';
      //String filePath = '$finalFolderName/$fileName.$extension';
      String filePath = '$folderName/$fileName.$extension';

      Reference reference = _storage.ref(filePath);
      UploadTask uploadTask = reference.putFile(file);

      try {
        TaskSnapshot taskSnapshot = await uploadTask;
        return await taskSnapshot.ref.getDownloadURL();
      } on FirebaseException catch (e) {
        debugPrint('FirebaseStorageService / uploadFile : ${e.code}');
        return null;
      }
    }
    return null;
  }

  @override
  Future<String?> uploadImageFile(
    String userId,
    String fileName,
    String folderName,
    File file,
  ) async {
    return await uploadFile(
      userId,
      fileName,
      folderName,
      file,
      '.jpg',
    );
  }

  @override
  Future<String?> uploadMessageImage(
    String senderId,
    String receiverId,
    String fileName,
    File imageFile,
  ) async {
    if (_firebaseSettings != null) {
      String finalFolderName = '${_firebaseSettings!.messagesFolderName}'
          '/$senderId/$receiverId';
      return await uploadImageFile(
        senderId,
        fileName,
        finalFolderName,
        imageFile,
      );
    }
    return null;
  }
}
