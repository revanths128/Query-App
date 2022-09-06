import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:question_and_answer/components/ButtonComponent.dart';
import 'package:question_and_answer/components/QuestionRequest.dart';
import 'package:question_and_answer/components/constants.dart';
import 'package:question_and_answer/components/header2.dart';
import 'package:question_and_answer/components/size_config.dart';
import 'package:question_and_answer/components/text.dart';
import 'package:question_and_answer/models/answer_model/database.dart';
import 'package:question_and_answer/models/question_model/database.dart';
import 'package:question_and_answer/models/user_model/database.dart';

class AnswerSubQuestion extends StatefulWidget {
  const AnswerSubQuestion(
      {required this.aid, required this.subQuestion, required this.subQid, required this.uidUser, required this.func});

  final String aid, subQuestion, subQid, uidUser;
  final void Function() func;

  @override
  _AnswerSubQuestionState createState() => _AnswerSubQuestionState();
}
class _AnswerSubQuestionState extends State<AnswerSubQuestion> {

  String answer = "";
  String question = "";
  bool loadData = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
    var qid;
    await FirebaseFirestore.instance
        .collection('answers')
        .doc(widget.aid)
        .get()
        .then((value){
      answer = value.data()!['answer'];
      qid = value.data()!['qid'];
    });
    await FirebaseFirestore.instance
        .collection('questions')
        .doc(qid)
        .get()
        .then((value) {
          question = value.data()!['question'];
    });
    setState(() {
      loadData = false;
    });
    }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Header2(text: ""),
                !loadData ? Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding:  EdgeInsets.only(left: getProportionateScreenWidth(20),
                  right: getProportionateScreenWidth(20),
                  top: getProportionateScreenHeight(20), bottom: getProportionateScreenHeight(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: TextWidget(
                              text: question,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              colorType: Colors.black,
                              textAlign: TextAlign.left),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: TextWidget(
                              text: answer,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              colorType: Colors.black,
                              textAlign: TextAlign.left),
                        ),
                        SizedBox(height: getProportionateScreenHeight(30),),
                        Padding(
                          padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: TextWidget(
                                    text: widget.subQuestion,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    colorType: Colors.black,
                                    textAlign: TextAlign.left),
                              ),
                              SizedBox(height: 5,),
                              QuestionRequest(height: 200, width: 360, text:"Type your answer here...", maxLines: 20, onChange: (value){}, controller: controller),
                            ],
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(30),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonComponent(
                              text: "Post",
                              press: () async {
                                if(controller.text != ""){
                                  var answerService = DatabaseAnswerService();
                                  final FirebaseAuth _auth = FirebaseAuth.instance;
                                  String uid = _auth.currentUser!.uid;
                                  String aid = await answerService.insertAnswerData(controller.text, widget.subQid, uid, false);
                                  var userService = DatabaseUserService();
                                  await userService.updateUserData(aid, "aid", "countAid");
                                  await userService.updateRequestQuestionData(widget.uidUser, uid, widget.subQid, 1);
                                  var questionService = DatabaseQuestionService();
                                  await questionService.updateQuestionData(widget.subQid, aid);
                                  controller.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: kPrimaryColor,
                                      content: Text('Answer posted')));
                                  widget.func();
                                  Navigator.pop(context);
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: kPrimaryColor,
                                      content: Text('Please type your answer')));
                                }
                              },
                              buttonWidth: 50,
                              buttonHeight: 30,
                              fontSizeLength: 15,
                              textColor: Colors.white,
                              borderColor: Colors.transparent,
                              backColor: kPrimaryColor,
                            )
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(200),),
                      ],
                    ),
                  ),
                ) : Center(child: CircularProgressIndicator(),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

