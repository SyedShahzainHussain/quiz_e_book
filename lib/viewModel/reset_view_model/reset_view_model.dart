import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz_e_book/repositories/reset_repo/reset_repo.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';

// ! package
import 'package:go_router/go_router.dart';

class ResetViewModel with ChangeNotifier {
  final ResetRepository resetRepository = ResetRepository();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void resetOtp(
    dynamic body,
    context,
  ) async {
    setLoading(true);
    resetRepository.resetOtp(body).then((value) {
      setLoading(false);
      Utils.flushBarErrorMessage("Your Password Reset", context);
      Future.delayed(const Duration(seconds: 2), () {
        GoRouter.of(context).go(
          RouteName.loginScreen,
        );
      });
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error);
      }
      Utils.flushBarErrorMessage(error.toString(), context);
    });
  }
}
