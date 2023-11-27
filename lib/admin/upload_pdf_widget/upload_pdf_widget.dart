import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_e_book/data/services/permission/media_services.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/view/e_book/e_book.dart';
import 'package:quiz_e_book/widget/button_widget.dart';
import 'package:quiz_e_book/widget/text_form_widget.dart';
import 'package:gap/gap.dart';

class UploadPdfWidget extends StatefulWidget {
  const UploadPdfWidget({super.key});

  @override
  State<UploadPdfWidget> createState() => _UploadPdfWidgetState();
}

class _UploadPdfWidgetState extends State<UploadPdfWidget> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  String? title;
  String? pdffile;
  File? image;

  Future<File?> showImage(ImageSource imageSource) async {
    var file = await MediaService.uploadImage(context, imageSource);
    setState(() {
      image = file;
    });
    return null;
  }

  void showModel() {
    showModalBottomSheet(
      backgroundColor: AppColors.bgColor,
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.white),
              onTap: () {
                showImage(
                  ImageSource.gallery,
                );
                Navigator.of(context).pop();
              },
              title: const Text(
                "Choose from gallery",
                style: TextStyle(color: AppColors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.white),
              onTap: () {
                showImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
              title: const Text(
                "Choose from camera",
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String?> pickFIle() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) {
      return null;
    } else {
      String file = result.files.first.path.toString();
      Utils.flushBarErrorMessage("Pdf Selected", context);
      return file;
    }
  }

  void onSave() async {
    final validate = _form.currentState!.validate();
    if (validate && image != null && pdffile != null) {
      _form.currentState!.save();
      if (kDebugMode) {
        print(title);
        print(pdffile);
        print(image!.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload PDF")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _form,
            child: Column(
              children: [
                Textformwidget(
                  onSave: (value) {
                    title = value;
                  },
                  title: "Title",
                  keyboardType: TextInputType.text,
                  icon: const Icon(Icons.title),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a title.";
                    }
                    return null;
                  },
                ),
                const Gap(20),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        height: context.screenheight * .2,
                        width: context.screenwidth * .4,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.bgColor3,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Center(
                          child: image == null
                              ? const Text("No Image")
                              : Image.file(
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: Column(
                        children: [
                          Buttonwidget(
                            text: "Book Image",
                            onTap: () {
                              showModel();
                            },
                          ),
                          const Gap(20),
                          Buttonwidget(
                            text: "Upload PDF",
                            onTap: () async {
                              pdffile = await pickFIle();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const Gap(20),
                Buttonwidget(
                    text: "Submit",
                    onTap: () {
                      onSave();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
