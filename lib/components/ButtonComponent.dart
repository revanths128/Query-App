import 'package:flutter/material.dart';
import 'package:question_and_answer/components/size_config.dart';

class ButtonComponent extends StatelessWidget {
  ButtonComponent(
      {required this.text,
      required this.press,
      required this.buttonWidth,
      required this.buttonHeight,
      required this.fontSizeLength,
      required this.borderColor,
      required this.backColor,
      required this.textColor});
  final String text;
  final void Function() press;
  final double buttonWidth;
  final double buttonHeight;
  final double fontSizeLength;
  final Color borderColor;
  final Color backColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(buttonWidth),
      height: getProportionateScreenHeight(buttonHeight),
      child: TextButton(
        style: TextButton.styleFrom(
          side: BorderSide(width: 1, color: borderColor),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: backColor,
        ),
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(fontSizeLength),
            color: textColor,
          ),
        ),
      ),
    );
  }
}
