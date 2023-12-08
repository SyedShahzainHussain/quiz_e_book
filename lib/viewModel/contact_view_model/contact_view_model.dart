import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz_e_book/repositories/contact_repo/contact_repo.dart';
import 'package:quiz_e_book/utils/utils.dart';

class ContactViewModel with ChangeNotifier {
  ContactRepo contactRepo = ContactRepo();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void postContact(dynamic body, String token, BuildContext context) async {
    setLoading(true);
    contactRepo.postContact(body, token).then((value) {
      setLoading(false);
      if (kDebugMode) {
        print(value);
      }
      Utils.flushBarErrorMessage(
          "Your detail has been send to the admin", context);
      body = null;
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
