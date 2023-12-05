import 'package:flutter/foundation.dart';
import 'package:quiz_e_book/repositories/deleted_user_repo/delete_user_repo.dart';

class DeleteUserViewModel with ChangeNotifier {
  DeletedUserRepo deletedUserRepo = DeletedUserRepo();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void deleteUser(String uid, {String? token}) async {
    setLoading(true);
    deletedUserRepo.deleteUser(uid, token: token).then((value) {
      setLoading(false);
      if (kDebugMode) {
        print(value);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error);
      }
    });
  }
}
