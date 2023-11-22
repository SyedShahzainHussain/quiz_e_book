import 'package:flutter/material.dart';

abstract class PermissionServices {
  Future requestPhotoPermission();
  Future<bool> handlePhotoPermission(BuildContext context);

  Future requestCameraPermission();
  Future<bool> handleCameraPermission(BuildContext context);
  
}
