import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ! package
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// ! file
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/extension/sizedbox_extension/sizedbox_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/viewModel/login_view_model/login_view_model.dart';
import 'package:quiz_e_book/widget/button_widget.dart';
import 'package:quiz_e_book/widget/text_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> obsecureText = ValueNotifier<bool>(true);
    final emailnode = FocusNode();
    final passwordnode = FocusNode();
    final form = GlobalKey<FormState>();
    String? emailController;
    String? passwordController;

    void safe() async {
      final validate = form.currentState!.validate();

      if (validate) {
        form.currentState!.save();
        final body = {
          "email": emailController,
          "password": passwordController,
        };
        context.read<LoginViewModel>().loginApi(body, context);
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.screenheight -
              MediaQuery.paddingOf(context).bottom -
              MediaQuery.paddingOf(context).top,
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
              child: Center(
                child: Form(
                  key: form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: context.screenheight * .09,
                        ),
                        Text(
                          "Login",
                          style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.displaySmall,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white),
                        ),
                        SizedBox(
                          height: context.screenheight * .09,
                        ),
                        Textformwidget(
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          focusNode: emailnode,
                          nextFocusNode: passwordnode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter email";
                            } else if (!value.contains('@')) {
                              return "Invalid format";
                            }
                            return null;
                          },
                          icon: const Icon(Icons.email_rounded),
                          onSave: (value) {
                            emailController = value;
                          },
                          title: "Email",
                        ),
                        10.height,
                        ValueListenableBuilder(
                          valueListenable: obsecureText,
                          builder: (context, value, _) => TextFormField(
                            textInputAction: TextInputAction.done,
                            focusNode: passwordnode,
                            obscureText: obsecureText.value,
                            onSaved: (value) {
                              passwordController = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter password";
                              } else if (value.length < 4) {
                                return "Password must be at least 4 characters long";
                              }
                              return null;
                            },
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
                        SizedBox(
                          height: context.screenheight * .05,
                        ),
                        Consumer<LoginViewModel>(
                          builder: (context, value, child) => Buttonwidget(
                            isLoading: value.isLoading,
                            text: "Login",
                            onTap: () {
                              safe();
                              // Navigator.pushNamed(context, RouteName.homeScreen);
                            },
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteName.forgotPasswordScreen);
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: AppColors.bgColor,
                                ),
                              ),
                            )),
                        SizedBox(
                          height: context.screenheight * .05,
                        ),
                        Text.rich(TextSpan(children: [
                          const TextSpan(
                              text: "Don't have an account?",
                              style: TextStyle(color: AppColors.bgColor)),
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                      context, RouteName.registeredScreen);
                                },
                              text: " Sign Up",
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
