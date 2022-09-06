import 'package:flutter/material.dart';
import 'package:question_and_answer/components/size_config.dart';


class ProfileMenu extends StatelessWidget {

  ProfileMenu({required this.text, required this.icon, this.press});

  final String text;
  final IconData icon;
  final VoidCallback? press;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20), vertical: getProportionateScreenHeight(10)),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.black,
          padding: EdgeInsets.all(20),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(
              icon,
              color: Color(0xff0558bb),
              size: 22,
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(Icons.arrow_forward_ios, color: Color(0xff0558bb),),
          ],
        ),
      ),
    );
  }
}


