import 'package:flutter/material.dart';
import 'package:quiz_e_book/admin/repository/get_contact_repo.dart';
import 'package:quiz_e_book/data/response/api_response.dart';
import 'package:quiz_e_book/model/contact_model.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';

class GetContactViewModel with ChangeNotifier {
  Future<LoginData> getUserData() => AuthViewModel().getUser();
  GetContactRepo contactRepo = GetContactRepo();
  ApiResponse<List<ContactModel>> apiResponse = ApiResponse.loading();

  setApiResponse(ApiResponse<List<ContactModel>> response) {
    apiResponse = response;
    notifyListeners();
  }

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;
  setisExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  Future<void> getContact() async {
    setApiResponse(ApiResponse.loading());
     getUserData().then((admin)async {
       contactRepo.getContact(admin.token!).then((value) {
        setApiResponse(ApiResponse.complete(value));
      }).onError((error, stackTrace) {
        setApiResponse(ApiResponse.error(error.toString()));
      });
    });
  }
}
