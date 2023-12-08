import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:quiz_e_book/viewModel/contact_view_model/contact_view_model.dart';
import 'package:quiz_e_book/widget/contact_textfeild.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  Future<LoginData> getUserData() => AuthViewModel().getUser();

  void _onSave() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        messageController.text.isEmpty) {
      return Utils.flushBarErrorMessage("Please fill all input", context);
    } else {
      final body = {
        "name": nameController.text.toString(),
        "email": emailController.text.toString(),
        "message": messageController.text.toString(),
      };
      getUserData().then((value) {
        return context
            .read<ContactViewModel>()
            .postContact(body, value.token!, context);
      });
      nameController.clear();
      emailController.clear();
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafbfd),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'C o n t a c t U s'.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff233849)),
                    ),
                    const Gap(10),
                    Text(
                      "FEEL FREE TO DROP US A MESSAGE!",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: context.screenheight * .05,
                ),
                ContactTextField.textfield(
                  context,
                  "NAME",
                  "Ashley Stephens",
                  null,
                  const FaIcon(FontAwesomeIcons.user,
                      color: AppColors.textColor),
                  nameController,
                ),
                ContactTextField.textfield(
                  context,
                  "EMAIL",
                  "ashley_s@gmail.com",
                  null,
                  const Icon(Icons.email, color: AppColors.textColor),
                  emailController,
                ),
                ContactTextField.textfield(
                  context,
                  "MESSAGE",
                  "Vestibulum rutrum quam vitae fringilla tincidunt...",
                  4,
                  const Icon(Icons.message, color: AppColors.textColor),
                  messageController,
                ),
                SizedBox(
                  height: context.screenheight * .05,
                ),
                Consumer<ContactViewModel>(
                  builder: (context, value, _) => GestureDetector(
                    onTap: () {
                      _onSave();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          color: const Color(0xffdd884d)),
                      child: Center(
                          child: value.isLoading
                              ? const SpinKitFadingCircle(
                                  color: AppColors.white,
                                )
                              : Text(
                                  "S E N D",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white),
                                )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
