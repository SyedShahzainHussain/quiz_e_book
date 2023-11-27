import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/widget/button_widget.dart';

class OtpScreen extends StatelessWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    String? verificationCode;

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
                "assets/images/otp.png",
                width: double.infinity,
                height: context.screenheight * .3,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      "Enter OTP",
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
                      "Enter 6 digit code has been send to your email address",
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Enter your OTP",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.titleMedium,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: OtpTextField(
                      numberOfFields: 6,
                      borderColor: AppColors.bgColor,
                      enabled: true,
                      focusedBorderColor: AppColors.bgColor,
                      enabledBorderColor: AppColors.bgColor4,
                      showFieldAsBox: true,

                      onSubmit: (String verificationCodes) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Verification Code"),
                                content:
                                    Text('Code entered is $verificationCodes'),
                              );
                            });
                        verificationCode = verificationCodes;
                      }, // end onSubmit
                    ),
                  ),
                  Buttonwidget(
                    text: "Send",
                    onTap: () {
                      GoRouter.of(context).push(RouteName.resetScreen, extra: {
                        "email": email.toString(),
                        "otp": verificationCode,
                      });
                    },
                  ),
                ],
              )
            ]),
          ),
        ));
  }
}
