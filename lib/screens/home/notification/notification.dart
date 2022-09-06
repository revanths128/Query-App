import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:question_and_answer/components/ButtonComponent.dart';
import 'package:question_and_answer/components/constants.dart';
import 'package:question_and_answer/components/modal.dart';
import 'package:question_and_answer/components/size_config.dart';
import 'package:question_and_answer/components/text.dart';
import 'package:question_and_answer/models/user_model/database.dart';
import 'package:question_and_answer/screens/home/notification/answer_sub_question.dart';

class NotificationAlert extends StatefulWidget {
  static String id = "notification";

  @override
  _NotificationAlertState createState() => _NotificationAlertState();
}

class _NotificationAlertState extends State<NotificationAlert> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isNotify = false, loadData = true;
  var questions = [], report;

  @override
  void initState() {
    super.initState();
    getQuestionsData();
  }

  getQuestionsData() async {
    var qids;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      qids = value.data()!['recQid'];
      report = value.data()!['report'];
      setState(() {
        isNotify = value.data()!['notifications'];
      });
    });
    for (var key in qids.keys) {
      await FirebaseFirestore.instance
          .collection('questions')
          .doc(key)
          .get()
          .then((value) {
        if (qids[key][1] == 0 && !report.containsKey(key)) {
          questions.add([
            key,
            value.data()!['question'],
            qids[key][0],
            value.data()!['mainAid']
          ]);
        }
      });
    }
    setState(() {
      loadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !loadData
        ? (isNotify
            ? Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (BuildContext context, int index) => Question(
                    question: questions[index][1],
                    qid: questions[index][0],
                    uid1: user!.uid,
                    uid2: questions[index][2],
                    mainAid: questions[index][3],
                    func: () {
                      setState(() {
                        questions.removeAt(index);
                      });
                    },
                  ),
                ),
              )
            : Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      'Turn on notifications on your settings to see notifications',
                    ),
                  ),
                ),
              ))
        : Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}

class Question extends StatefulWidget {
  const Question({
    required this.question,
    required this.qid,
    required this.uid1,
    required this.uid2,
    required this.mainAid,
    required this.func,
  });

  final String question;
  final String qid;
  final String uid1;
  final String uid2;
  final String mainAid;
  final void Function() func;

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
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
              TextWidget(
                fontSize: 15,
                colorType: Colors.black,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.left,
                text: widget.question,
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonComponent(
                      text: "Accept",
                      press: () async {
                        var mainQ;
                        await FirebaseFirestore.instance
                            .collection('questions')
                            .doc(widget.qid)
                            .get()
                            .then((value) {
                          mainQ = value.data()!['mainQ'];
                        });
                        if (mainQ == true) {
                          await showModalBottomSheet(
                            constraints: BoxConstraints(
                              maxHeight: getProportionateScreenHeight(700),
                            ),
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => Modal(
                              qid: widget.qid,
                              question: widget.question,
                              mainA: true,
                              userId: widget.uid2,
                            ),
                          );
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AnswerSubQuestion(
                                    subQuestion: widget.question,
                                    subQid: widget.qid,
                                    uidUser: widget.uid2,
                                    aid: widget.mainAid,
                                    func: widget.func,
                                  )));
                        }
                      },
                      buttonWidth: 50,
                      buttonHeight: 30,
                      fontSizeLength: 12,
                      borderColor: Colors.green,
                      backColor: Colors.white,
                      textColor: Colors.green),
                  SizedBox(
                    width: getProportionateScreenWidth(10),
                  ),
                  ButtonComponent(
                      text: "Deny",
                      press: () async {
                        var userDatabase = DatabaseUserService();
                        await userDatabase.updateRequestQuestionData(
                            widget.uid2, widget.uid1, widget.qid, -1);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: kPrimaryColor,
                            content: Text('Question Reported')));
                        widget.func();
                      },
                      buttonWidth: 50,
                      buttonHeight: 30,
                      fontSizeLength: 12,
                      borderColor: Colors.red,
                      backColor: Colors.white,
                      textColor: Colors.red),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
