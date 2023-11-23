import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/extension/sizedbox_extension/sizedbox_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/viewModel/forgot_password_view_model/forgot_password_view_model.dart';

import 'package:quiz_e_book/widget/button_widget.dart';
import 'package:quiz_e_book/widget/text_form_widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _form = GlobalKey<FormState>();
  String? emailController;
  void onSave() {
    final validate = _form.currentState!.validate();
    if (validate) {
      _form.currentState!.save();
      final body = {"email": emailController};
      context
          .read<ForgotPasswordViewModel>()
          .forgotPassword(body, emailController.toString(), context);
    
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Back",
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(children: [
            Image.asset(
              "assets/images/forgot.png",
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
                      "Forgot Password",
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
                      "Enter the email address associated with your account and we'll send an email with instructions on how to reset your password",
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Enter your email",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.titleMedium,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Textformwidget(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter email";
                        } else if (!value.contains('@')) {
                          return "Invalid format";
                        }
                        return null;
                      },
                      onSave: (value) {
                        emailController = value;
                      },
                      title: "Enter your email",
                      icon: const Icon(Icons.email_outlined),
                    ),
                  ),
                  5.height,
                  Consumer<ForgotPasswordViewModel>(
                    builder: (context, value, _) => Buttonwidget(
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
