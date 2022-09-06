import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:question_and_answer/components/constants.dart';
import 'package:question_and_answer/components/header2.dart';
import 'package:question_and_answer/components/question_answer.dart';
import 'package:question_and_answer/components/question_message.dart';
import 'package:question_and_answer/components/size_config.dart';
import 'package:question_and_answer/components/text.dart';
import 'package:question_and_answer/models/user_model/user_model.dart';
import 'package:question_and_answer/screens/home/profile/my_account/edit_profile.dart';
import '../../../../components/ButtonComponent.dart';
import '../../question/question.dart';

class MyAccount extends StatefulWidget {
  static String id = "my_account";
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseStorage storage = FirebaseStorage.instance;
  UserModel userModel = UserModel();
  var url;
  var questions = [];
  var questionsReceived = [];
  var questionsSent = [];
  var answerQuestions = [];
  bool loadUserData = true,
      loadQuestionData = true,
      loadAnswerData = true,
      loadReceiveData = true,
      loadSentData = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data());
    });
    url = await storage.ref('test/${user!.uid}').getDownloadURL();
    if (mounted) {
      setState(() {
        loadUserData = false;
      });
    }
    await getQuestions(userModel.qid);
    if (mounted) {
      setState(() {
        loadQuestionData = false;
      });
    }
    await getAnswersQuestions(userModel.aid);
    if (mounted) {
      setState(() {
        loadAnswerData = false;
      });
    }
    await getUserRequestsReceivedData(userModel.recQid);
    if (mounted) {
      setState(() {
        loadReceiveData = false;
      });
    }
    await getUserRequestsSentData(userModel.sentQid);
    if (mounted) {
      setState(() {
        loadSentData = false;
      });
    }
  }

  getUserRequestsSentData(var qids) async {
    for (var key in qids.keys) {
      await FirebaseFirestore.instance
          .collection('questions')
          .doc(key)
          .get()
          .then((value) {
        questionsSent
            .add([value.data()!['qid'], value.data()!['question'], qids[key][1]]);
      });
    }
  }

  getUserRequestsReceivedData(var qids) async {
    for (var key in qids.keys) {
      await FirebaseFirestore.instance
          .collection('questions')
          .doc(key)
          .get()
          .then((value) {
        questionsReceived
            .add([value.data()!['qid'], value.data()!['question'], qids[key][1]]);
      });
    }
  }

  getAnswersQuestions(var aids) async {
    for (int i = 0; i < aids.length; i++) {
      var val1 = "", val2 = "", qid = "", mainQ;
      await FirebaseFirestore.instance
          .collection('answers')
          .doc(aids[i])
          .get()
          .then((value) {
        val1 = value.data()!['answer'];
        qid = value.data()!['qid'];
      });
      await FirebaseFirestore.instance
          .collection('questions')
          .doc(qid)
          .get()
          .then((value) {
        val2 = value.data()!['question'];
        mainQ = value.data()!['mainQ'];
      });
      answerQuestions.add([qid, val2, val1, mainQ]);
    }
  }

  getQuestions(var qids) async {
    for (int i = 0; i < qids.length; i++) {
      await FirebaseFirestore.instance
          .collection('questions')
          .doc(qids[i])
          .get()
          .then((value) {
        questions.add([value.data()!['qid'], value.data()!['question'], value.data()!['mainQ']]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: !loadUserData
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Header2(text: "Profile"),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(115),
                      height: getProportionateScreenHeight(115),
                      child: url != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(url!),
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/profile.jpg"),
                            ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(20),
                          right: getProportionateScreenWidth(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                text: "Your Info",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                colorType: Colors.black,
                                textAlign: TextAlign.left,
                              ),
                              ButtonComponent(
                                text: "Edit",
                                buttonWidth: getProportionateScreenWidth(50),
                                buttonHeight: getProportionateScreenHeight(30),
                                fontSizeLength: 15.0,
                                textColor: Colors.white,
                                borderColor: Colors.transparent,
                                backColor: kPrimaryColor,
                                press: () {
                                  Navigator.pushNamed(context, EditProfile.id);
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              TextWidget(
                                text: "Name: ",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                colorType: Colors.black,
                                textAlign: TextAlign.left,
                              ),
                              TextWidget(
                                text: "${userModel.username}",
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                colorType: Colors.black,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              TextWidget(
                                text: "Designation: ",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                colorType: Colors.black,
                                textAlign: TextAlign.left,
                              ),
                              TextWidget(
                                text: "${userModel.designation}",
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                colorType: Colors.black,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              TextWidget(
                                text: "Department: ",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                colorType: Colors.black,
                                textAlign: TextAlign.left,
                              ),
                              TextWidget(
                                text: "${userModel.department}",
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                colorType: Colors.black,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              TextWidget(
                                text: "Joined: ",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                colorType: Colors.black,
                                textAlign: TextAlign.left,
                              ),
                              TextWidget(
                                text: "${userModel.joined}",
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                colorType: Colors.black,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      child: AppBar(
                        backgroundColor: Colors.white,
                        bottom: TabBar(
                          labelColor: Color(0xff0558bb),
                          unselectedLabelColor: Colors.black38,
                          indicatorColor: Color(0xff0558bb),
                          isScrollable: true,
                          tabs: [
                            Tab(
                              text: "Questions Asked(${userModel.countQid})",
                            ),
                            Tab(
                              text: "Questions Answered(${userModel.countAid})",
                            ),
                            Tab(
                              text: "Requests Sent(${userModel.countSentQid})",
                            ),
                            Tab(
                              text:
                                  "Requests Received(${userModel.countRecQid})",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // first tab bar view widget
                          !loadQuestionData
                              ? Container(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: questions.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              QuestionMessage(
                                            question: questions[index][1],
                                            qid: questions[index][0],
                                                mainQ: questions[index][2],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),

                          // second tab bar view widget
                          !loadAnswerData
                              ? Container(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: answerQuestions.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    getProportionateScreenHeight(
                                                        20)),
                                            child: Column(
                                              children: [
                                                QuestionAnswerBubble(
                                                  id: answerQuestions[
                                                  index]
                                                  [0],
                                                  func: (){},
                                                  contText:
                                                      answerQuestions[index][1],
                                                  onPress: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Question(
                                                                    qid: answerQuestions[
                                                                            index]
                                                                        [0], mainQ: answerQuestions[index][3], )));
                                                  },
                                                  check: true,
                                                  txt: '',
                                                  isHome: false,
                                                ),
                                                QuestionAnswerBubble(
                                                  id: answerQuestions[
                                                  index]
                                                  [0],
                                                  func: (){},
                                                  contText:
                                                      answerQuestions[index][2],
                                                  onPress: () {},
                                                  check: false,
                                                  txt: '',
                                                  isHome: false,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                          !loadSentData
                              ? Container(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: questionsSent.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              RequestBubble(
                                            question: questionsSent[index][1],
                                            qid: questionsSent[index][0],
                                            check: questionsSent[index][2],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),

                          // second tab bar view widget
                          !loadReceiveData
                              ? Container(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: questionsReceived.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              RequestBubble(
                                            question: questionsReceived[index]
                                                [1],
                                            qid: questionsReceived[index][0],
                                            check: questionsReceived[index][2],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

class RequestBubble extends StatelessWidget {
  const RequestBubble(
      {required this.question, required this.qid, required this.check});

  final String question;
  final String qid;
  final int check;

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                fontSize: 15,
                colorType: Colors.black,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.left,
                text: question,
              ),
              check == 0
                  ? TextWidget(
                      fontSize: 15,
                      colorType: Colors.yellow,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.left,
                      text: "Pending",
                    )
                  : check == 1
                      ? TextWidget(
                          fontSize: 15,
                          colorType: Colors.green,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.left,
                          text: "Accepted",
                        )
                      : TextWidget(
                          fontSize: 15,
                          colorType: Colors.red,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.left,
                          text: "Denied",
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
