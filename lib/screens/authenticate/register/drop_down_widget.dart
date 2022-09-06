import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropDownWidget extends StatelessWidget {
  DropDownWidget(
      {required this.hintText,
      required this.validate,
      required this.designationRoles,
      required this.onChange, required this.label, this.value});

  final String hintText;
  final String label;
  final String? Function(String?) validate;
  final List<String> designationRoles;
  final void Function(String?) onChange;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 13.0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        style: TextStyle(fontSize: 15),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(right: 20),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: designationRoles
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: validate,
      onChanged: onChange,
    );
  }
}
