import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:question_and_answer/components/circle_image.dart';
import 'package:question_and_answer/components/constants.dart';
import 'package:question_and_answer/components/header1.dart';
import 'package:question_and_answer/components/text.dart';
import 'package:question_and_answer/screens/home/profile/profile.dart';
import 'home/answer/answer.dart';
import 'home/add/add.dart';
import 'home/home/home.dart';
import 'home/notification/notification.dart';

class Start extends StatefulWidget {
  static String id = "start";
  @override
  _StartState createState() => new _StartState();
}

class _StartState extends State<Start> {

  String? url;
  bool load = true;
  int _currentIndex = 0;
  List _screens = [
    Home(),
    Ask(),
    Answer(),
    NotificationAlert(),
    Profile(),
  ];
  List _titles = ["Home", "Add", "Answer", "Notification", "Profile"];

  void _updateIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  void initState() {
    super.initState();
    getUrl();
  }

  Future getUrl() async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = _auth.currentUser!.uid;
    url = await storage.ref('test/$fileName').getDownloadURL();
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: !load ? Column(
          children: [
            (_currentIndex == 3 || _currentIndex == 4) ? Header1(
              text: _titles[_currentIndex], isSearch: false, image: CircleImage(url: url,),) : Header1(
              text: _titles[_currentIndex], isSearch: true, image: CircleImage(url: url,),),
            _screens[_currentIndex],
          ],
        ) : Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Center(child: TextWidget(
            text: "QUERY",
            fontWeight: FontWeight.bold,
            fontSize: 40,
            colorType: kPrimaryColor,
            textAlign: TextAlign.left,
          ),),
        ),
        bottomNavigationBar: !load ? BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _updateIndex,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.black45,
          iconSize: 25,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: _titles[0],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: _titles[1],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notes),
              label: _titles[2],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_outlined),
              label: _titles[3],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: _titles[4],
            ),
          ],
        ) : Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(child: TextWidget(
        text: "QUERY",
        fontWeight: FontWeight.bold,
        fontSize: 40,
        colorType: kPrimaryColor,
        textAlign: TextAlign.left,
      ),),
    ),
      )
    );
  }
}
