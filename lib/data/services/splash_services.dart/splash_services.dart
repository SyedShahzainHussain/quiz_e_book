import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashService with ChangeNotifier {
  Future<LoginData> getUserData() => AuthViewModel().getUser();
  AuthViewModel authViewModel = AuthViewModel();
  final __tokenExpiredController = StreamController<bool>();
  Stream<bool> get onTokenExpired => __tokenExpiredController.stream;

  void checkAuthentication(BuildContext context) async {
    getUserData().then((value) async {
      if (value.token == null || value.token == "") {
        GoRouter.of(context).go(RouteName.loginScreen);
      } else {
        bool isTokenExpired = JwtDecoder.isExpired(value.token.toString());
        if (isTokenExpired) {
          authViewModel.remove();
          __tokenExpiredController.add(true);
          // ignore: use_build_context_synchronously
          GoRouter.of(context).go(RouteName.loginScreen);
        }

        // ignore: use_build_context_synchronously
        GoRouter.of(context).go(RouteName.homeScreen);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
