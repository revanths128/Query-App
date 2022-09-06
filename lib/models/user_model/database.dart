import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseUserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  updateUserData(String uid, String id, String cid) async {
    User? user = _auth.currentUser;
    List<dynamic> list = [];
    var count;
    await firebaseFirestore
        .collection("users")
        .doc(user?.uid)
        .get()
        .then((value) => list = value.data()![id]);
    await firebaseFirestore
        .collection("users")
        .doc(user?.uid)
        .get()
        .then((value) => count = value.data()![cid]);
    list.add(uid);
    count = int.parse(count);
    count++;
    await firebaseFirestore
        .collection("users")
        .doc(user?.uid)
        .update({id: list, cid: count.toString()});
  }

  editUserData(String name, String designation, String department) async{
    User? user = _auth.currentUser;
    await firebaseFirestore
        .collection("users")
        .doc(user?.uid)
        .update({"username": name, "designation": designation, "department": department});
  }


  updateRequestData(String uid1, String uid2, String qid) async{
    var count;
    var map1, map2;
    await firebaseFirestore
        .collection("users")
        .doc(uid1)
        .get()
        .then((value){
          count = value.data()!["countSentQid"];
          map1 = value.data()!["sentQid"];
    });
    map1[qid] = [uid2, 0];
    count = int.parse(count);
    count++;
    await firebaseFirestore
        .collection("users")
        .doc(uid1)
        .update({"sentQid": map1, "countSentQid": count.toString()});
    await firebaseFirestore
        .collection("users")
        .doc(uid2)
        .get()
        .then((value){
          count = value.data()!["countRecQid"];
          map2 = value.data()!["recQid"];
    });
    map2[qid] = [uid1, 0];
    count = int.parse(count);
    count++;
    await firebaseFirestore
        .collection("users")
        .doc(uid2)
        .update({"recQid": map2, "countRecQid": count.toString()});
  }

  updateRequestQuestionData(String uid1, String uid2, String qid, int flag) async{
    var map1, map2;
    await firebaseFirestore
        .collection("users")
        .doc(uid1)
        .get()
        .then((value) => map1 = value.data()!["sentQid"]);
    map1[qid] = [uid2, flag];
    await firebaseFirestore
        .collection("users")
        .doc(uid1)
        .update({"sentQid": map1});
    await firebaseFirestore
        .collection("users")
        .doc(uid2)
        .get()
        .then((value) => map2 = value.data()!["recQid"]);
    map2[qid] = [uid1, flag];
    await firebaseFirestore
        .collection("users")
        .doc(uid2)
        .update({"recQid": map2});
  }

  updateNotificationSetting(bool value) async{
    User? user = _auth.currentUser;
    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .update({"notifications": value});
  }

  updateUserReportData(String qid) async{
    User? user = _auth.currentUser;
    var report;
    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) => report = value.data()!["report"]);
    report[qid] = "";
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .update({"report": report});
  }
}
