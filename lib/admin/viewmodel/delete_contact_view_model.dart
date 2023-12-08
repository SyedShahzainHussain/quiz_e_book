import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_e_book/admin/repository/delete_contact_repo.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';

class DeleteContactViewModel with ChangeNotifier {
  DeleteContactRepo deletingRatingRepo = DeleteContactRepo();
  Future<LoginData> getUserData() => AuthViewModel().getUser();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void deletedContact(String ratingID, BuildContext context) {
    setLoading(true);
    getUserData().then((admin) {
      deletingRatingRepo.deletedContact(ratingID, admin.token!).then((value) {
        setLoading(false);
        if (kDebugMode) {
          print(value);
        }
        context.pop();
      }).onError((error, stackTrace) {
        setLoading(false);
        if (kDebugMode) {
          print(error);
        }
      });
    });
  }
}
