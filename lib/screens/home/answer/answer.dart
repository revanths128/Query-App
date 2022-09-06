import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:question_and_answer/components/ButtonComponent.dart';
import 'package:question_and_answer/components/constants.dart';
import 'package:question_and_answer/components/size_config.dart';
import 'package:question_and_answer/components/text.dart';
import 'package:question_and_answer/models/user_model/database.dart';

import '../../../components/modal.dart';

class Answer extends StatefulWidget {
  static String id = "answer";

  @override
  _AnswerState createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {

  var questions = [];
  bool loadData = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
    User? user = FirebaseAuth.instance.currentUser;
    var report;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      report = value.data()!['report'];
    });
    var collection = FirebaseFirestore.instance.collection('questions');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if (data['countAns'] == '0' && data['mainQ'] == true && !report.containsKey(data['qid'])) {
        questions.add([data['question'], data['qid'], user.uid]);
      }
    }
    setState(() {
      loadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: !loadData ? ListView.builder(
        itemCount: questions.length,
        itemBuilder: (BuildContext context, int index) => QuestionBubble(question: questions[index][0], qid: questions[index][1], uid: questions[index][2], func: (){
          setState(() {
            questions.removeAt(index);
          });
        },),
      ) : Center(child: CircularProgressIndicator(),),
    );
  }
}

class QuestionBubble extends StatefulWidget {
  QuestionBubble({required this.question, required this.qid, required this.uid, required this.func});
  final String qid;
  final String question;
  final String uid;
  final void Function() func;

  @override
  State<QuestionBubble> createState() => _QuestionBubbleState();
}

class _QuestionBubbleState extends State<QuestionBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        height: getProportionateScreenHeight(120),
        child: Padding(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(20),
              top: getProportionateScreenHeight(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                  text: widget.question,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  colorType: Colors.black,
                  textAlign: TextAlign.left),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
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
                            qid: widget.qid,
                            question: widget.question,
                            mainA: true,
                            userId: widget.uid,
                          ),
                        );
                        widget.func();
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
                        await userDatabase.updateUserReportData(widget.qid);
                        widget.func();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: kPrimaryColor,
                            content: Text('Question Reported')));
                      },
                      buttonWidth: 60,
                      buttonHeight: 30,
                      fontSizeLength: 14,
                      borderColor: Colors.red,
                      backColor: Colors.white,
                      textColor: Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
