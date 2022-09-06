import 'package:flutter/material.dart';
import 'package:question_and_answer/components/size_config.dart';
import 'package:question_and_answer/components/text.dart';
import 'package:question_and_answer/models/user_model/database.dart';

import 'ButtonComponent.dart';
import 'constants.dart';

class QuestionAnswerBubble extends StatefulWidget {
  QuestionAnswerBubble(
      {required this.contText,
      required this.onPress,
      required this.check,
      required this.txt,
      required this.isHome, required this.id, required this.func});

  final String contText;
  final String txt;
  final String id;
  final void Function() onPress;
  final void Function() func;
  final bool check;
  final bool isHome;

  @override
  State<QuestionAnswerBubble> createState() => _QuestionAnswerBubbleState();
}

class _QuestionAnswerBubbleState extends State<QuestionAnswerBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(20),
              top: getProportionateScreenHeight(10),
              bottom: getProportionateScreenHeight(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: widget.onPress,
                child: TextWidget(
                    text: widget.contText,
                    fontWeight: widget.check ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 15,
                    colorType: Colors.black,
                    textAlign: TextAlign.left),
              ),
              widget.isHome
                  ? SizedBox(
                      height: 10,
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
              widget.isHome
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                            text: widget.txt,
                            fontWeight: FontWeight.w100,
                            fontSize: 15,
                            colorType: Colors.black,
                            textAlign: TextAlign.left),
                        ButtonComponent(
                            text: "Report",
                            press: () async{
                              var userDatabase = DatabaseUserService();
                              await userDatabase.updateUserReportData(widget.id);
                              if(widget.check){
                                widget.func();
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: kPrimaryColor,
                                    content: Text('Question Reported')));
                              } else{
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: kPrimaryColor,
                                    content: Text('Answer Reported')));
                              }
                            },
                            buttonWidth: 60,
                            buttonHeight: 30,
                            fontSizeLength: 14,
                            borderColor: Colors.red,
                            backColor: Colors.white,
                            textColor: Colors.red),
                      ],
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
