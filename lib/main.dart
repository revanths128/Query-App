import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:question_and_answer/screens/authenticate/login/forgot_password.dart';
import 'package:question_and_answer/screens/authenticate/login/login.dart';
import 'package:question_and_answer/screens/authenticate/register/register.dart';
import 'package:question_and_answer/screens/authenticate/welcome/welcome.dart';
import 'package:question_and_answer/screens/home/add/add.dart';
import 'package:question_and_answer/screens/home/home/home.dart';
import 'package:question_and_answer/screens/home/notification/notification.dart';
import 'package:question_and_answer/screens/home/profile/help/helpCenter.dart';
import 'package:question_and_answer/screens/home/profile/my_account/edit_profile.dart';
import 'package:question_and_answer/screens/home/profile/my_account/my_account.dart';
import 'package:question_and_answer/screens/home/profile/profile.dart';
import 'package:question_and_answer/screens/home/profile/settings/settings.dart';
import 'package:question_and_answer/screens/services/auth.dart';
import 'package:question_and_answer/screens/start.dart';
import 'package:question_and_answer/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'components/search.dart';
import 'models/user_model/user_model.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
         home: Wrapper(),
        routes: {
          Welcome.id: (context) => Welcome(),
          Login.id: (context) => Login(),
          Register.id: (context) => Register(),
          ForgotPassword.id: (context) => ForgotPassword(),
          Home.id: (context) => Home(),
          Ask.id: (context) => Ask(),
          Contact.id: (context) => Contact(),
          MyAccount.id: (context) => MyAccount(),
          Profile.id: (context) => Profile(),
          Setting.id: (context) => Setting(),
          Start.id: (context) => Start(),
          Search.id: (context) => Search(),
          EditProfile.id: (context) => EditProfile(),
          NotificationAlert.id: (context) => NotificationAlert(),
        },
      ),
    );
  }
}