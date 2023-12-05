import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz_e_book/repositories/update_level/update_level.dart';

class UpdateLevelViewModel with ChangeNotifier {
  UpdateLevel updateLevels = UpdateLevel();

  void updateLevel(String token, dynamic body, BuildContext context) async {
    updateLevels.updateLevel(body, token).then((value) {
      if (kDebugMode) {
        print(value);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}
