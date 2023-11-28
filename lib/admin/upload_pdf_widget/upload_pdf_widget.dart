import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/data/services/permission/media_services.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/uploadfle_view_model/upload_file_viewModel.dart';
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
  TextEditingController titileContrpller = TextEditingController();

  String? title;
  File? pdffile;
  File? image;
  @override
  dispose() {
    super.dispose();
    titileContrpller.dispose();
  }

  Future<Uint8List?> showImage(ImageSource imageSource) async {
    var file = await MediaService.uploadImage2(context, imageSource);
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

  Future<File?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null) {
        return null;
      }

      List<File> files = result.files.map((file) => File(file.path!)).toList();

      if (files.isEmpty) {
        return null;
      }

      File? fileBytes = files.first.absolute;
      Utils.flushBarErrorMessage("Pdf Selected", context);
      return fileBytes;
    } catch (e) {
      Utils.flushBarErrorMessage("Error picking file: $e", context);
      return null;
    }
  }

  void onSave() async {
    final validate = _form.currentState!.validate();
    if (!validate && image == null && pdffile == null) {
      return;
    }
    if (validate && pdffile != null && image != null) {
      _form.currentState!.save();

      context
          .read<UploadFileViewModel>()
          .uploadFiletoFirestore(pdffile, image, context, title!)
          .then((value) {
      
      });
    } else {
      Utils.flushBarErrorMessage("Add All Fields", context);
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
                  controller: titileContrpller,
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
                              pdffile = await pickFile();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const Gap(20),
                Consumer<UploadFileViewModel>(
                  builder: (context, value, child) {
                    return Buttonwidget(
                        isLoading: value.isLoading,
                        text: "Submit",
                        onTap: () {
                          onSave();
                        });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
