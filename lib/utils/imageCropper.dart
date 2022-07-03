import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

Future<File> cropImage(File currentThumbnail) async {
  File? croppedFile = await ImageCropper().cropImage(
      sourcePath: currentThumbnail.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              // CropAspectRatioPreset.square,
              // CropAspectRatioPreset.ratio3x2,
              // CropAspectRatioPreset.original,
              // CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              //     CropAspectRatioPreset.original,
              //     CropAspectRatioPreset.square,
              //     CropAspectRatioPreset.ratio3x2,
              //     CropAspectRatioPreset.ratio4x3,
              //     CropAspectRatioPreset.ratio5x3,
              //     CropAspectRatioPreset.ratio5x4,
              //     CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          hideBottomControls: false,
          lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ));
  if (croppedFile != null) {
    return croppedFile;
  } else {
    return currentThumbnail;
  }
}
