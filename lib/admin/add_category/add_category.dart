import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/admin/viewmodel/category_view_model.dart';
import 'package:quiz_e_book/data/services/permission/media_services.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:quiz_e_book/widget/button_widget.dart';
import 'package:quiz_e_book/widget/text_form_widget.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  Future<LoginData> getUserData() => AuthViewModel().getUser();

  final _form = GlobalKey<FormState>();
  File? image;
  String? title;

  Future<Uint8List?> showImage(ImageSource imageSource) async {
    var file = await MediaService.uploadImage2(context, imageSource);
    setState(() {
      image = file;
    });
    return null;
  }

  void save() async {
    final validate = _form.currentState!.validate();
    if (!validate) return;
    if (validate && image != null) {
      _form.currentState!.save();
      getUserData().then((value) {
        context.read<CategoryViewModel>().uploadCategory(
              image,
              context,
              title!,
              value.token!,
            );
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Textformwidget(
                  onSave: (value) {
                    title = value;
                  },
                  title: "Title",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter the title number";
                    }

                    return null;
                  }),
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
                    child: Buttonwidget(
                      text: "Category Image",
                      onTap: () {
                        showModel();
                      },
                    ),
                  )
                ],
              ),
              const Gap(10),
              Consumer<CategoryViewModel>(
                builder: (context, value, _) => Buttonwidget(
                    isLoading: value.isLoading,
                    text: "Submit",
                    onTap: () {
                      save();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
