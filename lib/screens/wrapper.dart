import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_and_answer/models/user_model/user_model.dart';
import 'package:question_and_answer/screens/authenticate/welcome/welcome.dart';
import 'package:question_and_answer/screens/start.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if (user == null){
      return Welcome();
    } else {
      return Start();
    }
  }
}
