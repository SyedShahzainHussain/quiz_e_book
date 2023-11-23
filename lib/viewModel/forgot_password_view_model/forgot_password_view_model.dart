import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz_e_book/repositories/forgot_repo/forgot_password_repo.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';

class ForgotPasswordViewModel with ChangeNotifier {
  final ForgotPasswordRepo forgotPasswordRepo = ForgotPasswordRepo();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void forgotPassword(dynamic body, String email, context) async {
    setLoading(true);
    forgotPasswordRepo.forgotPassword(body).then((value) {
      setLoading(false);
      Navigator.pushNamed(context, RouteName.otpScreen, arguments: email);
      Utils.flushBarErrorMessage("OTP has been send to your email", context);
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error);
      }
      Utils.flushBarErrorMessage(error.toString(), context);
    });
  }
}
