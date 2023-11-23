import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashService {
  Future<LoginData> getUserData() => AuthViewModel().getUser();

  void checkAuthentication(BuildContext context) async {
    getUserData().then((value) async {
      if (value.token == null || value.token == "") {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.loginScreen, (route) => false);
      } else {
        bool isTokenExpired = JwtDecoder.isExpired(value.token.toString());
        print(isTokenExpired);
        if (isTokenExpired) {
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.remove("token");
        }

        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.homeScreen, (route) => false);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
