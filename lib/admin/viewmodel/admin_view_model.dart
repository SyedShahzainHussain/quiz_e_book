import 'package:flutter/material.dart';
import 'package:quiz_e_book/admin/repository/admin_repo.dart';

class AdminViewModel with ChangeNotifier {
  AdminRepo adminRepo = AdminRepo();
 bool _isloading = false;
  bool get isLoading => _isloading;
  setLoading(bool loading) {
    _isloading = loading;
    notifyListeners();
  }

  void adminLogin(dynamic body) async {
       setLoading(true);
    adminRepo
        .adminLogin(body)
        .then((value) {
             setLoading(false);
        })
        .onError((error, stackTrace) => null);
  }
}
