import 'package:flutter/material.dart';
import 'package:question_and_answer/components/icon_widget.dart';
import 'package:question_and_answer/components/search.dart';
import 'package:question_and_answer/components/size_config.dart';
import 'circle_image.dart';

class Header1 extends StatelessWidget {

  Header1({required this.text, required this.isSearch, required this.image});

  final bool isSearch;
  final String text;
  final CircleImage image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(50),
      decoration: BoxDecoration(
        color: Color(0xff0558bb),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: getProportionateScreenWidth(20), right: getProportionateScreenWidth(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(30),
                  width: getProportionateScreenWidth(30),
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      image,
                    ],
                  ),
                ),
                SizedBox(width: 15.0,),
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
            isSearch ? IconWidget(icons: Icons.search, onPress: (){
             Navigator.pushNamed(context, Search.id);
            },) : SizedBox(width: 0, height: 0,),
          ],
        ),
      ),
    );
  }
}
