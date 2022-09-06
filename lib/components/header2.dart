import 'package:flutter/material.dart';
import 'package:question_and_answer/components/icon_widget.dart';
import 'package:question_and_answer/components/size_config.dart';

class Header2 extends StatelessWidget {
  Header2({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(50),
      decoration: BoxDecoration(
        color: Color(0xff0558bb),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            left: getProportionateScreenWidth(10),
            right: getProportionateScreenWidth(20)),
        child: Row(
          children: [
            IconWidget(
                icons: Icons.arrow_back_ios,
                onPress: () {
                  Navigator.pop(context);
                }),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
