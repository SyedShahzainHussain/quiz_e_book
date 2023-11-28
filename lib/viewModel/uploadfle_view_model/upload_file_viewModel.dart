import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_e_book/firebase/firebase_storage/firebase_storeage.dart';
import 'package:quiz_e_book/model/pdf_upload_model.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:uuid/uuid.dart';

class UploadFileViewModel with ChangeNotifier {
  StorageModel storageModel = StorageModel();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  get isLoading => _isLoading;

  setLoading(loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> uploadFiletoFirestore(
      File? pdffile, File? image, BuildContext context, String title) async {
    setLoading(true);
    storageModel
        .uploadImage("pdf", pdffile!, context, "application")
        .then((value1) {
      storageModel
          .uploadImage("image", image!, context, "image")
          .then((value2) {
        final datas = PdfUploadMOdel(
          dateTime: DateTime.now().toIso8601String(),
          id: const Uuid().v1(),
          imagefile: value2,
          pdffile: value1,
          title: title,
        );
        firebaseFirestore
            .collection("files")
            .doc(const Uuid().v1())
            .set(
              datas.toJSon(),
            )
            .then((value) {
          setLoading(false);
          context.go(RouteName.homeScreen);

          Future.delayed(const Duration(seconds: 1), () {
            Utils.flushBarErrorMessage("Upload Successfully", context);
          });
        }).onError((error, stackTrace) {
          setLoading(false);
        });
      });
    });
  }
}
