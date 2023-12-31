import 'package:flutter/material.dart';

class Textformwidget extends StatelessWidget {
  final Function(String?)? onSave;
  final String title;
  final Widget? icon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  const Textformwidget({
    super.key,
    required this.onSave,
    required this.title,
    this.icon,
    this.validator,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType:keyboardType ,
      focusNode: focusNode,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(nextFocusNode),
      validator: validator,
      textInputAction: textInputAction,
      onSaved: onSave,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: title,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );
  }
}
