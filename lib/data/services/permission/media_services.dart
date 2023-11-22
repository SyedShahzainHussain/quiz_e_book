import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// ! package
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image_picker/image_picker.dart';
import 'package:quiz_e_book/data/services/permission/permission_handler_service.dart';
import 'package:quiz_e_book/data/services/permission/permission_services.dart';

class MediaService {
  static final PermissionServices permissionServices =
      PermissionHandlerPermssionService();

static  Future<bool> handleImageUploadPermission(
      BuildContext context, ImageSource? image) async {
    if (image == null) {
      return false;
    }
    if (image == ImageSource.camera) {
      return await permissionServices.handleCameraPermission(context);
    } else if (image == ImageSource.gallery) {
      return await permissionServices.handlePhotoPermission(context);
    } else {
      return false;
    }
  }

  static Future<File?> uploadImage(BuildContext context, ImageSource? imageSource,
      {bool shouldCompress = true}) async {
    bool canproceed = await handleImageUploadPermission(context, imageSource);

    if (canproceed) {
      File? processedPickedImageFile;
      final imagePicker = ImagePicker();
      final rawPickedImageFile =
          await imagePicker.pickImage(source: imageSource!, imageQuality: 50);

      if (rawPickedImageFile != null) {
        processedPickedImageFile = File(rawPickedImageFile.path);
        if (shouldCompress) {
          processedPickedImageFile =
              await compressFile(processedPickedImageFile);
        }
      }
      return processedPickedImageFile;
    }
    return null;
  }

 static Future<File?> compressFile(File file, {int quality = 30}) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath =
        '${dir.absolute.path}/${Random().nextInt(1000)}-temp.jpg';
    final image = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: quality);
    return File(image!.path);
  }
}
