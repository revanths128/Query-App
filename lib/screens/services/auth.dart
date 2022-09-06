import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  postDetailsToFirestore(
    String username,
    String designation,
    String department,
  ) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    UserModel userModel = UserModel(
      email: user!.email,
      username: username,
      designation: designation,
      department: department,
      uid: user.uid,
      joined: formattedDate.toString(),
      countAid: '0',
      countQid: '0',
      countRecQid: '0',
      countSentQid: '0',
      qid: [],
      aid: [],
      recQid: {} as LinkedHashMap<dynamic, dynamic>,
      sentQid: {} as LinkedHashMap<dynamic, dynamic>,
      notifications: false,
      report: {} as LinkedHashMap<dynamic, dynamic>,
    );
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
  }

  Future registerWithEmailAndPassword(
    String email,
    String password,
    String username,
    String designation,
    String department,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      postDetailsToFirestore(username, designation, department);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
