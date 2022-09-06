import 'package:flutter/material.dart';

import 'custom_surfix_icon.dart';

class BuildFormField extends StatelessWidget {
  BuildFormField(
      {required this.obscure,
      required this.onChange,
      required this.onSave,
      required this.validate,
      required this.label,
      required this.hint,
      required this.image,
      this.controller});

  final bool obscure;
  final void Function(String) onChange;
  final void Function(String?) onSave;
  final String? Function(String?) validate;
  final String label;
  final String hint;
  final String image;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      onSaved: onSave,
      onChanged: onChange,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        suffixIcon: CustomSurffixIcon(svgIcon: image),
      ),
    );
  }
}
