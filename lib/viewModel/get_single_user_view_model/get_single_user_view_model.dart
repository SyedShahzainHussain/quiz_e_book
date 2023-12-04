import 'package:flutter/foundation.dart';
import 'package:quiz_e_book/data/response/api_response.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/model/users.dart';
import 'package:quiz_e_book/repositories/get_single_user/get_single_user.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';

class GetSingleUserViewModel with ChangeNotifier {
  GetSingleUser getSingleUser = GetSingleUser();
  ApiResponse<Map<String, dynamic>> apiresponse = ApiResponse.loading();
  Future<LoginData> getUserData() => AuthViewModel().getUser();

  setUserList(ApiResponse<Map<String, dynamic>> response) {
    apiresponse = response;
    notifyListeners();
  }

  Future<void> getSingleUsers(String token, String userId) async {
    setUserList(ApiResponse.loading());

    try {
      final loginData = await getUserData();
      final userMap = await getSingleUser
          .getSingleUser({"Authorization": "Bearer $token"}, loginData.sId!);

      setUserList(ApiResponse.complete(userMap));
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }

      setUserList(ApiResponse.error(error.toString()));
    }
  }
}
