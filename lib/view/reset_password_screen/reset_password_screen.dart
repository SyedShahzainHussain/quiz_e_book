import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/extension/sizedbox_extension/sizedbox_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/viewModel/reset_view_model.dart/reset_view_model.dart';
import 'package:quiz_e_book/widget/button_widget.dart';
import 'package:quiz_e_book/widget/text_form_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const ResetPasswordScreen({super.key, required this.data});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ValueNotifier<bool> obsecureText = ValueNotifier<bool>(true);
  final _form = GlobalKey<FormState>();
  String? passwordController;
  void onSave() {
    final validate = _form.currentState!.validate();
    if (validate) {
      _form.currentState!.save();
      final body = {
        "email": widget.data['email'],
        "otp": widget.data['otp'],
        "newPassword": passwordController
      };
      context.read<ResetViewModel>().resetOtp(body, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Back"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(children: [
            Image.asset(
              "assets/images/reset.png",
              width: double.infinity,
              height: context.screenheight * .3,
            ),
            Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      "Reset Password",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.titleLarge,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Enter the new password associated with your account and we'll reset your password",
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "New Password",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.titleMedium,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: obsecureText,
                    builder: (context, value, child) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Textformwidget(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter password";
                          } else if (value.length < 4) {
                            return "Password must be at least 4 characters long";
                          }
                          return null;
                        },
                        obsecure: obsecureText.value,
                        sufficIcon: IconButton(
                          onPressed: () {
                            obsecureText.value = !obsecureText.value;
                          },
                          icon: Icon(
                            obsecureText.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        onSave: (value) {
                          passwordController = value;
                        },
                        title: "New Password",
                        icon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: FaIcon(
                            obsecureText.value
                                ? FontAwesomeIcons.lock
                                : FontAwesomeIcons.unlock,
                          ),
                        ),
                      ),
                    ),
                  ),
                  5.height,
                  Consumer<ResetViewModel>(
                    builder: (context,value,_)=>
                   Buttonwidget(
                    isLoading: value.isLoading,
                      text: "Send",
                      onTap: () {
                        onSave();
                      },
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
