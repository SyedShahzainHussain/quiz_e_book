import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// ! package
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image_picker/image_picker.dart';

class MediaService {
  static Future<Uint8List?> uploadImage(
      BuildContext context, ImageSource? imageSource,
      {bool shouldCompress = true}) async {
    final imagePicker = ImagePicker();
    final rawPickedImageFile =
        await imagePicker.pickImage(source: imageSource!, imageQuality: 50);

    if (rawPickedImageFile != null) {
      return rawPickedImageFile.readAsBytes();
    }
    return null;
  }

  // static Future<Uint8List?> compressFile(File? file, {int quality = 30}) async {
  //   final dir = await path_provider.getTemporaryDirectory();
  //   final targetPath =
  //       '${dir.absolute.path}/${Random().nextInt(1000)}-temp.jpg';
  //   final image = await FlutterImageCompress.compressAndGetFile(
  //       file!.absolute.path, targetPath,
  //       quality: quality);
  //   return image!.readAsBytes();
  // }

  static Future<File?> uploadImage2(
      BuildContext context, ImageSource? imageSource,
      {bool shouldCompress = true}) async {
    File? processedPickedImageFile;
    File? file;
    final imagePicker = ImagePicker();
    final rawPickedImageFile =
        await imagePicker.pickImage(source: imageSource!, imageQuality: 50);

    if (rawPickedImageFile != null) {
      processedPickedImageFile = File(rawPickedImageFile.path);
      if (shouldCompress) {
        file = await compressFile2(processedPickedImageFile);
      }
    }
    return File(file!.path);
  }

  static Future<File?> compressFile2(File? file, {int quality = 30}) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath =
        '${dir.absolute.path}/${Random().nextInt(1000)}-temp.jpg';
    final image = await FlutterImageCompress.compressAndGetFile(
        file!.absolute.path, targetPath,
        quality: quality);
    return File(image!.path);
  }
}
