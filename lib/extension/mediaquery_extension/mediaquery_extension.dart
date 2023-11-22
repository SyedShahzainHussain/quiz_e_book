import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  double get screenheight => MediaQuery.sizeOf(this).height * 1;
  double get screenwidth => MediaQuery.sizeOf(this).width * 1;
}
