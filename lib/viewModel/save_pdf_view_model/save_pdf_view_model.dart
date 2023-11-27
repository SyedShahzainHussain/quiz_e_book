import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

class SavePDFViewModel with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

 
Future<File?> storeFile(
    BuildContext context,
    String sourcePath,
    String filename,
  ) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');

    setLoading(true);

    try {
      await File(sourcePath).copy(file.path);

     
      setLoading(false);

      if (kDebugMode) {
        print(file);
      }

      return file;
    } catch (e) {
      
      setLoading(false);
      return null;
    }
  }

}
