import 'package:flutter/foundation.dart';
import 'package:quiz_e_book/admin/repository/admin_user_rating_repo.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/model/rating_model.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';

import '../../data/response/api_response.dart';

class AdminUserRatingViewModel with ChangeNotifier {
  AdminUserRatingRepo adminUserRatingRepo = AdminUserRatingRepo();
  Future<LoginData> getUserData() => AuthViewModel().getUser();

  ApiResponse<List<RatingModel>> apiresponse = ApiResponse.loading();

  setAdminRatingList(ApiResponse<List<RatingModel>> response) {
    apiresponse = response;
    notifyListeners();
  }

  Future<void> getAdminUserRating() async {
    setAdminRatingList(ApiResponse.loading());
    getUserData().then((admin) {
      adminUserRatingRepo.getUserRating(admin.token!).then((value) {
        if (kDebugMode) {
          print(value);
        }
        setAdminRatingList(ApiResponse.complete(value));
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print(error.toString());
        }
        setAdminRatingList(ApiResponse.error(error.toString()));
      });
    });
  }
}
