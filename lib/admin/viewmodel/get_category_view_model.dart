import 'package:flutter/material.dart';
import 'package:quiz_e_book/admin/repository/get_category.dart';
import 'package:quiz_e_book/data/response/api_response.dart';
import 'package:quiz_e_book/model/categorises.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';

class GetCategoryViewModel with ChangeNotifier {
  Future<LoginData> getUserData() => AuthViewModel().getUser();
  GetCategoryRepo categoryRepo = GetCategoryRepo();
  ApiResponse<List<Categories>> apiResponse = ApiResponse.loading();

  setCategoryList(ApiResponse<List<Categories>> apiResponse) {
    this.apiResponse = apiResponse;
    notifyListeners();
  }

  Future<void> getCategory()async {
    setCategoryList(ApiResponse.loading());
   await  getUserData().then((value)  async {
     await categoryRepo.getCategory(value.token!).then((data) {
        setCategoryList(ApiResponse.complete(data));
      }).onError((error, stackTrace) {
        setCategoryList(ApiResponse.error(error.toString()));
      });
    });
  }
}
