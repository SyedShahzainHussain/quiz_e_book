import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz_e_book/repositories/score_update/score_update_repo.dart';

class ScoreViewModel with ChangeNotifier {
  ScoreUpdateRepo scoreUpdateRepo = ScoreUpdateRepo();
  bool _isLoading = false;
  bool get loading => _isLoading;
  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> updateScore(String url, dynamic body, BuildContext context,
      {Map<String, String>? headers}) async {
    setLoading(true);
    scoreUpdateRepo.updateScore(url, body, headers: headers).then((value) {
      if (kDebugMode) {
        print(value);
      }
      setLoading(false);
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
      setLoading(false);
    });
  }
}
