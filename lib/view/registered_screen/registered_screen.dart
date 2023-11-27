import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ! package
import 'package:google_fonts/google_fonts.dart';
import 'package:dob_input_field/dob_input_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/data/services/permission/media_services.dart';

// ! file
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/extension/sizedbox_extension/sizedbox_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';

import 'package:quiz_e_book/viewModel/registered_view_model.dar/registered_view_model.dart';

import 'package:quiz_e_book/widget/button_widget.dart';
import 'package:quiz_e_book/widget/text_form_widget.dart';

class RegisteredScreen extends StatefulWidget {
  const RegisteredScreen({super.key});

  @override
  State<RegisteredScreen> createState() => _RegisteredScreenState();
}

class _RegisteredScreenState extends State<RegisteredScreen> {
  final ValueNotifier<bool> obsecureText = ValueNotifier<bool>(true);

  final form = GlobalKey<FormState>();
  FocusNode namenode = FocusNode();
  FocusNode emailnode = FocusNode();
  FocusNode dateOfBirthnode = FocusNode();
  FocusNode passwordnode = FocusNode();

  String? emailController;
  String? passwordController;
  String? usernameController;
  String? dateOfBirth;
  File? image;

  void safe() async {
    final validate = form.currentState!.validate();
    if (validate && image != null) {
      form.currentState!.save();

      context.read<RegisteredViewModel>().registerApi(
            usernameController.toString(),
            emailController.toString(),
            passwordController.toString(),
            dateOfBirth.toString(),
            image,
            context,
          );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.screenheight,
          child: Stack(children: [
            Container(
              height: context.screenheight * .35,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(500.0),
                    bottomRight: Radius.circular(500.0)),
                gradient: LinearGradient(
                  colors: [
                    AppColors.bgColor,
                    AppColors.bgColor2,
                    AppColors.bgColor3,
                  ],
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: form,
                    child: Column(
                      children: [
                        SizedBox(
                          height: context.screenheight * .09,
                        ),
                        Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.displaySmall,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white),
                        ),
                        SizedBox(
                          height: context.screenheight * .09,
                        ),
                        SizedBox(
                          height: context.screenheight * .1,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                  radius: 50,
                                  backgroundColor: AppColors.bgColor4,
                                  backgroundImage:
                                      image == null ? null : FileImage(image!)),
                              Positioned(
                                bottom: -10,
                                right: 0,
                                child: IconButton(
                                    onPressed: () async {
                                      showModel();
                                    },
                                    icon: const Icon(Icons.camera_alt)),
                              )
                            ],
                          ),
                        ),
                        20.height,
                        Textformwidget(
                          textInputAction: TextInputAction.next,
                          focusNode: namenode,
                          nextFocusNode: emailnode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a name";
                            }
                            return null;
                          },
                          icon: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: FaIcon(FontAwesomeIcons.user),
                          ),
                          onSave: (value) {
                            usernameController = value;
                          },
                          title: "Name",
                        ),
                        10.height,
                        Textformwidget(
                          textInputAction: TextInputAction.next,
                          focusNode: emailnode,
                          keyboardType: TextInputType.emailAddress,
                          nextFocusNode: passwordnode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter email";
                            } else if (!value.contains('@')) {
                              return "Invalid format";
                            }
                            return null;
                          },
                          icon: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: FaIcon(FontAwesomeIcons.envelope),
                          ),
                          onSave: (value) {
                            emailController = value;
                          },
                          title: "Email",
                        ),
                        10.height,
                        ValueListenableBuilder(
                          valueListenable: obsecureText,
                          builder: (context, value, _) => TextFormField(
                            focusNode: passwordnode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            onSaved: (value) {
                              passwordController = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter password";
                              } else if (value.length < 6) {
                                return "Password must be at least 6 characters long";
                              }
                              return null;
                            },
                            obscureText: obsecureText.value,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: FaIcon(
                                  obsecureText.value
                                      ? FontAwesomeIcons.lock
                                      : FontAwesomeIcons.unlock,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  obsecureText.value = !obsecureText.value;
                                },
                                icon: Icon(
                                  obsecureText.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              hintText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                            ),
                          ),
                        ),
                        10.height,
                        DOBInputField(
                          fieldLabelText: "Date of birth",
                          firstDate: DateTime(1900),
                          showLabel: true,
                          lastDate: DateTime.now(),
                          onDateSaved: (value) {
                            dateOfBirth =
                                '${DateTime(value.year, value.month, value.day)}';
                          },
                          inputDecoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: FaIcon(FontAwesomeIcons.calendar),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                        ),
                        SizedBox(
                          height: context.screenheight * .05,
                        ),
                        Consumer<RegisteredViewModel>(
                          builder: (context, value, child) => Buttonwidget(
                            isLoading: value.isLoading,
                            text: "Register",
                            onTap: () {
                              safe();
                            },
                          ),
                        ),
                        SizedBox(
                          height: context.screenheight * .05,
                        ),
                        Text.rich(TextSpan(children: [
                          const TextSpan(
                              text: "Already have an account?",
                              style: TextStyle(color: AppColors.bgColor)),
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.go(RouteName.loginScreen);
                                  
                                },
                              text: " Log In",
                              style: const TextStyle(
                                color: AppColors.grey,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.bgColor,
                              )),
                        ])),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
