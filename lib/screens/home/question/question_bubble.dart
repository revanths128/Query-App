import 'package:flutter/material.dart';
import 'package:question_and_answer/components/ButtonComponent.dart';
import 'package:question_and_answer/components/constants.dart';
import 'package:question_and_answer/components/modal.dart';
import 'package:question_and_answer/components/size_config.dart';
import 'package:question_and_answer/components/text.dart';
import 'package:question_and_answer/models/user_model/database.dart';

class QuestionBubble extends StatelessWidget {
  QuestionBubble(
      {required this.question, required this.name, required this.qid, required this.uid});

  final String question;
  final String qid;
  final String name;
  final String uid;

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(20),
            top: getProportionateScreenHeight(20), bottom: getProportionateScreenHeight(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
                text: "Asked by $name",
                fontWeight: FontWeight.w100,
                fontSize: 15,
                colorType: Colors.black,
                textAlign: TextAlign.left),
            SizedBox(height: getProportionateScreenHeight(20),),
            TextWidget(
                text: question,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                colorType: Colors.black,
                textAlign: TextAlign.left),
            SizedBox(height: getProportionateScreenHeight(15),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonComponent(
                    text: "Answer",
                    press: () {
                      showModalBottomSheet(
                        constraints: BoxConstraints(
                          maxHeight: getProportionateScreenHeight(700),
                        ),
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => Modal(
                          qid: qid,
                          question: question,
                          mainA: true,
                          userId: uid,
                        ),
                      );
                    },
                    buttonWidth: 60,
                    buttonHeight: 30,
                    fontSizeLength: 14,
                    borderColor: Colors.green,
                    backColor: Colors.white,
                    textColor: Colors.green),
                ButtonComponent(
                    text: "Report",
                    press: () async{
                      var userDatabase = DatabaseUserService();
                      await userDatabase.updateUserReportData(qid);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: kPrimaryColor,
                          content: Text('Question Reported')));
                      Navigator.pop(context);
                    },
                    buttonWidth: 60,
                    buttonHeight: 30,
                    fontSizeLength: 14,
                    borderColor: Colors.red,
                    backColor: Colors.white,
                    textColor: Colors.red),
              ],
            )
          ],
        ),
      ),
    );
  }
}
