import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_e_book/repositories/verify_repo/verify_repo.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';

class VerifyVewModel with ChangeNotifier {
  VerifyRepo verifyRepo = VerifyRepo();

  bool _isLoading = false;
  get isLoading => _isLoading;

  setLoading(loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void verify(dynamic data, BuildContext context) {
    setLoading(true);
    verifyRepo.verify(data).then((value) {
      if (kDebugMode) {
        print(value);
      }
      setLoading(false);
      Utils.flushBarErrorMessage("Your email has been verified", context);
      Future.delayed(const Duration(seconds: 2), () {
        context.go(RouteName.loginScreen);
      });
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
      setLoading(false);
      Utils.flushBarErrorMessage(error.toString(), context);
    });
  }
}
