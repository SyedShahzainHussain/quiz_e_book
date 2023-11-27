import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_e_book/admin/admin_screen/admin_screen.dart';
import 'package:quiz_e_book/admin/login_screen/login_screen.dart';
import 'package:quiz_e_book/admin/upload_pdf_widget/upload_pdf_widget.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/view/e_book/e_book.dart';
import 'package:quiz_e_book/view/forgot_password/forgot_password_screen.dart';
import 'package:quiz_e_book/view/home_screen/home_screen.dart';
import 'package:quiz_e_book/view/login_screen/login_screen.dart';
import 'package:quiz_e_book/view/otp_screen.dart/otp_screen.dart';
import 'package:quiz_e_book/view/registered_screen/registered_screen.dart';
import 'package:quiz_e_book/view/reset_password_screen/reset_password_screen.dart';
import 'package:quiz_e_book/view/safe_pdf_screen/save_pdf_screen.dart';
import 'package:quiz_e_book/view/splash_screen/splash_screen.dart';
import 'package:quiz_e_book/view/user_profile_screen.dart/user_profile_screen.dart';

class AppRoute {
  static final router = GoRouter(routes: [
    GoRoute(
      path: "/",
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: RouteName.loginScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: RouteName.registeredScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const RegisteredScreen();
      },
    ),
    GoRoute(
      path: RouteName.forgotPasswordScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const ForgotPassword();
      },
    ),
    GoRoute(
      path: RouteName.otpScreen,
      builder: (BuildContext context, GoRouterState state) {
        return OtpScreen(
          email: state.extra.toString(),
        );
      },
    ),
    GoRoute(
      path: RouteName.homeScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: RouteName.userProfileScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const UserProfileScreen();
      },
    ),
    GoRoute(
      path: RouteName.ebookScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const Ebook();
      },
    ),
    GoRoute(
      path: RouteName.pdfviewScreen,
      builder: (BuildContext context, GoRouterState state) {
        final String id = state.extra.toString();
        return PdfViewScreen(
          id: id,
        );
      },
    ),
    GoRoute(
      path: RouteName.resetScreen,
      builder: (BuildContext context, GoRouterState state) {
        return ResetPasswordScreen(data: state.extra as Map<String, dynamic>);
      },
    ),
    GoRoute(
      path: RouteName.savePdfScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const SafePdfScreen();
      },
    ),

    // ! admin screen
    GoRoute(
      path: RouteName.adminLoginScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreenAdmin();
      },
    ),
    GoRoute(
      path: RouteName.adminScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const AdminScreen();
      },
    ),
    GoRoute(
      path: RouteName.uploadPdfScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const UploadPdfWidget();
      },
    )
    ,

  ]);
}
