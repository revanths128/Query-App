import 'package:flutter/cupertino.dart';
import 'package:question_and_answer/components/size_config.dart';

class TextWidget extends StatelessWidget {
  TextWidget({required this.text, required this.fontWeight, required this.fontSize, required this.colorType, required this.textAlign});
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final Color colorType;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: getProportionateScreenWidth(fontSize),
        color: colorType,
      ),
      textAlign: textAlign,
    );
  }
}
