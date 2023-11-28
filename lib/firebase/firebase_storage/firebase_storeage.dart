import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:uuid/uuid.dart';

class StorageModel {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> uploadImage(
      String childname, File file, BuildContext context,String type) async {
    try {
      String fileType = file.path.split('.').last;
      Reference ref =
          storage.ref().child("book").child(childname).child(const Uuid().v1());
      UploadTask uploadTask = ref.putFile(
          File(file.path).absolute,
          SettableMetadata(
              contentType: '$type/$fileType',
              customMetadata: {'picked-file-path': file.path}));
      TaskSnapshot taskSnapshot = await uploadTask;
      String download = await taskSnapshot.ref.getDownloadURL();

      return download;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      Utils.flushBarErrorMessage(e.toString(), context);
      return null;
    }
  }
}
