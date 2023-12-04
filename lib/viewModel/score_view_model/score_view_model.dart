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

  Future<void> updateScore(dynamic body, BuildContext context,{Map<String, String>? headers}) async {
    try {
      setLoading(true);
      scoreUpdateRepo.updateScore(body,headers: headers).then((value) {
        setLoading(false);
      }).onError((error, stackTrace) {
        setLoading(false);
      });
    } catch (e) {
      setLoading(false);
    }
  }
}
