import 'package:flutter/material.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/view/e_book/e_book.dart';
import 'package:quiz_e_book/view/forgot_password/forgot_password_screen.dart';
import 'package:quiz_e_book/view/home_screen/home_screen.dart';
import 'package:quiz_e_book/view/login_screen/login_screen.dart';
import 'package:quiz_e_book/view/otp_screen.dart/otp_screen.dart';
import 'package:quiz_e_book/view/registered_screen/registered_screen.dart';
import 'package:quiz_e_book/view/splash_screen/splash_screen.dart';
import 'package:quiz_e_book/view/user_profile_screen.dart/user_profile_screen.dart';

class AppRoute {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // * splash route screen
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      // * login route screen
      case RouteName.loginScreen:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      // * register route screen
      case RouteName.registeredScreen:
        return MaterialPageRoute(
            builder: (context) => const RegisteredScreen());
      // * forgot password route screen
      case RouteName.forgotPasswordScreen:
        return MaterialPageRoute(builder: (context) => const ForgotPassword());
      // * otp route screen
      case RouteName.otpScreen:
        return MaterialPageRoute(builder: (context) => const OtpScreen());
      // * home route screen
      case RouteName.homeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      // * userprofile  route screen
      case RouteName.userProfileScreen:
        return MaterialPageRoute(
            builder: (context) => const UserProfileScreen());
      // * ebook route screen
      case RouteName.ebookScreen:
        return MaterialPageRoute(builder: (context) => const Ebook());
      // * pdfview route screen
      case RouteName.pdfviewScreen:
        return MaterialPageRoute(builder: (context) => const PdfViewScreen());
      // * default route screen
      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                    body: Center(
                  child: Text("No Routes Defined"),
                )));
    }
  }
}
