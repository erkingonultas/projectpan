import 'package:flutter/material.dart';
import 'package:projectpan/backend/constants.dart';

class TextContainer extends StatelessWidget {
  const TextContainer({
    Key? key,
    required this.controller,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    this.focusNode,
  }) : super(key: key);
  final TextEditingController controller;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: const TextStyle(color: woodsmoke),
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
