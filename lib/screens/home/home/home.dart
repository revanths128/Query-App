import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:question_and_answer/components/question_answer.dart';
import 'package:question_and_answer/components/size_config.dart';
import '../question/question.dart';

class Home extends StatefulWidget {
  static String id = "home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var questionAnswers = [];
  bool loadData = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
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
      if (data['countAns'] != '0' && data['mainQ'] == true && !report.containsKey(data['qid'])) {
        var question = data['question'];
        var qid = data['qid'];
        var aid = data['aid'];
        int randomIndex = Random().nextInt(aid.length);
        var fAid = aid[randomIndex];
        var asked = data['asked'];
        var askedName = await getUser(asked);
        await getAnswer(qid, question, fAid, askedName);
      }
    }
  }

  getAnswer(var qid, var question, var aid, var askedName) async {
    var answer = "";
    var uid = "";
    var answeredName = "";
    await FirebaseFirestore.instance
        .collection("answers")
        .doc(aid)
        .get()
        .then((value) {
      answer = value.data()!['answer'];
      uid = value.data()!['answered'];
    });
    answeredName = await getUser(uid);
    questionAnswers.add([qid, question, askedName, answer, answeredName, aid]);
    if(questionAnswers.length >= 3 && mounted){
      setState(() {
        loadData = false;
      });
    }
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
    return Expanded(
      child: !loadData ? ListView.builder(
        itemCount: questionAnswers.length,
        itemBuilder: (BuildContext context, int index) => QuestionAnswer(
          qid: questionAnswers[index][0],
          question: questionAnswers[index][1],
          askName: questionAnswers[index][2],
          answer: questionAnswers[index][3],
          answerName: questionAnswers[index][4],
          aid: questionAnswers[index][5],
          func: (){
            setState(() {
              questionAnswers.removeAt(index);
            });
          },
        ),
      ) : Center(child: CircularProgressIndicator(),),
    );
  }
}

class QuestionAnswer extends StatelessWidget {
  QuestionAnswer(
      {required this.question,
      required this.qid,
      required this.askName,
      required this.answerName,
      required this.answer, required this.aid, required this.func});
  final String question;
  final String qid;
  final String aid;
  final String askName;
  final String answerName;
  final String answer;
  final void Function() func;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: getProportionateScreenHeight(20)),
      child: Column(
        children: [
          QuestionAnswerBubble(
            func: func,
            id: qid,
            contText: question,
            txt: "Asked by $askName",
            onPress: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Question(qid: qid, mainQ: true,)));
            },
            check: true,
            isHome: true,
          ),
          QuestionAnswerBubble(
            func: func,
            id: aid,
            contText: answer,
            txt: "Answered by $answerName",
            onPress: () {},
            check: false,
            isHome: true,
          )
        ],
      ),
    );
  }
}
