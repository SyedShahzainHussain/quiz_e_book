import 'package:flutter/material.dart';
import 'package:quiz_e_book/data/services/permission/permission_services.dart';

// ! package
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerPermssionService extends PermissionServices {
  @override

  // ! handle camera
  Future<bool> handleCameraPermission(BuildContext context) async {
    PermissionStatus cameraPermissionStatus = await requestCameraPermission();
    if (cameraPermissionStatus != PermissionStatus.granted) {
      // ignore: use_build_context_synchronously
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: [
                  FilledButton(
                      onPressed: () {
                        openAppSettings()
                            .then((value) => Navigator.pop(context));
                      },
                      child: const Text("Settings"))
                ],
                title: const Text("Camera Permission"),
                content: const Text(
                    'Camera permission should Be granted to use this feature, would you like to go to app settings to give camera permission?'),
              ));
      return false;
    }
    return true;
  }

//! handle photo

  @override
  Future<bool> handlePhotoPermission(BuildContext context) async {
    PermissionStatus permissionStatus = await requestPhotoPermission();
    if (permissionStatus != PermissionStatus.granted) {
      // ignore: use_build_context_synchronously
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: [
                  FilledButton(
                      onPressed: () {
                        openAppSettings()
                            .whenComplete(() => Navigator.pop(context));
                      },
                      child: const Text("Settings"))
                ],
                title: const Text("Photos Permission"),
                content: const Text(
                    'Photos permission should Be granted to use this feature, would you like to go to app settings to give photos permission?'),
              ));
      return false;
    }
    return true;
  }

// ! handle camera permission
  @override
  Future requestCameraPermission() async {
    return await Permission.camera.request();
  }

// ! handle photo permission
  @override
  Future requestPhotoPermission() async {
    return await Permission.photos.request();
  }
}
