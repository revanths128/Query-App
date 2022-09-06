import 'package:flutter/material.dart';

class QuestionRequest extends StatelessWidget {
  QuestionRequest({
    required this.height,
    required this.width,
    required this.text,
    required this.maxLines,
    required this.onChange,
    required this.controller,
  });

  final double height;
  final double width;
  final int maxLines;
  final String text;
  final void Function(String) onChange;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        onChanged: onChange,
        maxLines: maxLines,
        autocorrect: true,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black12),
          ),
        ),
      ),
    );
  }
}
