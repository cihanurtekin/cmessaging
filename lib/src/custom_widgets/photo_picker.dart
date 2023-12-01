import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPicker {
  late String _takePhotoText;
  late String _chooseFromGalleryText;
  late String _cancelText;
  late double _maxImageWidth;

  PhotoPicker({
    required String takePhotoText,
    required String chooseFromGalleryText,
    required String cancelText,
    maxImageWidth = 400.0,
  }) {
    _takePhotoText = takePhotoText;
    _chooseFromGalleryText = chooseFromGalleryText;
    _cancelText = cancelText;
    _maxImageWidth = maxImageWidth;
  }

  Future<File?> pick(BuildContext context) async {
    int? result = await showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text(_takePhotoText),
              onTap: () => Navigator.pop(context, 0),
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text(_chooseFromGalleryText),
              onTap: () => Navigator.pop(context, 1),
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text(_cancelText),
              onTap: () => Navigator.pop(context, 2),
            ),
          ],
        );
      },
    );

    if (result != null) {
      ImageSource? source = result == 0
          ? ImageSource.camera
          : result == 1
              ? ImageSource.gallery
              : null;

      return await _getImage(source);
    }
    return null;
  }

  Future<File?> _getImage(ImageSource? source) async {
    if (source != null) {
      ImagePicker imagePicker = ImagePicker();
      XFile? pickedFile = await imagePicker.pickImage(
        source: source,
        maxWidth: _maxImageWidth,
      );

      if (pickedFile != null) {
        // TODO: Implement crop
        return /*cropImage
            ? await _cropImage(context, pickedFile.path)
            :*/
            File(pickedFile.path);
      }
    }
    return null;
  }
}
