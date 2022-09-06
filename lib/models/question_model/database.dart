import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:question_and_answer/models/question_model/question_model.dart';
import 'package:uuid/uuid.dart';

class DatabaseQuestionService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<String> insertQuestionData(String question, String asked, bool mainQ, String mainAid) async {
    String qid = Uuid().v4();
    QuestionModel questionModel =
        QuestionModel(qid: qid, question: question, mainQ: mainQ, countAns: '0', aid: [], asked: asked, mainAid: mainAid);
    await firebaseFirestore
        .collection("questions")
        .doc(qid)
        .set(questionModel.toMap());
    return qid;
  }

  updateQuestionData(String qid, String aid) async {
    List<dynamic> list = [];
    var count;
    await firebaseFirestore
        .collection("questions")
        .doc(qid)
        .get()
        .then((value) => list = value.data()!['aid']);
    await firebaseFirestore
        .collection("questions")
        .doc(qid)
        .get()
        .then((value) => count = value.data()!['countAns']);
    list.add(aid);
    count = int.parse(count);
    count++;
    await firebaseFirestore
        .collection("questions")
        .doc(qid)
        .update({'aid': list, 'countAns': count.toString()});
  }
}
