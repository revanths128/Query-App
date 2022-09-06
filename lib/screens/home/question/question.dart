import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:question_and_answer/components/header2.dart';
import 'package:question_and_answer/components/size_config.dart';
import 'package:question_and_answer/components/text.dart';
import 'package:question_and_answer/screens/home/question/question_bubble.dart';
import 'answer_bubble.dart';

class Question extends StatefulWidget {

  Question({required this.qid, required this.mainQ});

  final String qid;
  final bool mainQ;

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  var question = "", aid = [], count = "", askedName = "", asked = "", mainQid = "";
  bool loadQuestion = true;


  @override
  void initState() {
    super.initState();
    getQuestionData();
  }

  Future getQuestionData() async {
    if(widget.mainQ == false){
      await FirebaseFirestore.instance
          .collection("questions")
          .doc(widget.qid)
          .get()
          .then((value) async{
        var mainAid = value.data()!['mainAid'];
        await FirebaseFirestore.instance
            .collection("answers")
            .doc(mainAid)
            .get()
            .then((value){
              mainQid = value.data()!['qid'];
        });
      });
    } else{
      mainQid = widget.qid;
    }
    await FirebaseFirestore.instance
        .collection("questions")
        .doc(mainQid)
        .get()
        .then((value) {
      question = value.data()!['question'];
      count = value.data()!['countAns'];
      aid = value.data()!['aid'];
      asked = value.data()!['asked'];
    });
    askedName = await getUser(asked);
    setState(() {
      loadQuestion = false;
    });
  }

  Future<dynamic> getUser(var uid) async {
    var val = "";
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      val = value.data()!['username'];
    });
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Header2(
              text: '',
            ),
            Expanded(child:
            !loadQuestion ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuestionBubble(
                  qid: mainQid,
                  name: askedName,
                  question: question,
                  uid: asked,
                ),
                Padding(
                  padding: EdgeInsets.only(left: getProportionateScreenWidth(20), top: getProportionateScreenHeight(12)),
                  child: SizedBox(
                    height: getProportionateScreenHeight(30),
                    child: TextWidget(
                      textAlign: TextAlign.left,
                      text: '$count answers',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      colorType: Colors.black,
                    ),
                  ),
                ),
                AnswerBubble(aid: aid),
              ],
            ) : Center(child: CircularProgressIndicator(),),
            ),
          ],
        ),
      ),
    );
  }
}
