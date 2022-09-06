import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:question_and_answer/components/ButtonComponent.dart';
import 'package:question_and_answer/components/constants.dart';
import 'package:question_and_answer/components/size_config.dart';
import 'package:question_and_answer/components/text.dart';
import 'package:question_and_answer/screens/authenticate/components/build_form_field.dart';
import 'package:question_and_answer/screens/authenticate/components/form_error.dart';
import 'no_account.dart';

class ForgotPassword extends StatelessWidget {
  static String id = "forgot_password";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Forgot Password"),
          backgroundColor: kPrimaryColor,
        ),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(28),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  TextWidget(
                    text:
                        "Please enter your email and we will send \nyou a link to return to your account",
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w400,
                    fontSize: getProportionateScreenWidth(15),
                    colorType: Colors.black,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.1),
                  ForgotPassForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          BuildFormField(
              obscure: false,
              onChange: (value) {
                if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                  setState(() {
                    errors.remove(kEmailNullError);
                  });
                } else if (emailValidatorRegExp.hasMatch(value) &&
                    errors.contains(kInvalidEmailError)) {
                  setState(() {
                    errors.remove(kInvalidEmailError);
                  });
                }
                return null;
              },
              onSave: (newValue) => email = newValue!,
              validate: (value) {
                if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                  setState(() {
                    errors.add(kEmailNullError);
                  });
                } else if (!emailValidatorRegExp.hasMatch(value) &&
                    !errors.contains(kInvalidEmailError)) {
                  setState(() {
                    errors.add(kInvalidEmailError);
                  });
                }
                return null;
              },
              label: "Email",
              hint: "Enter your email",
              image: "assets/icons/Mail.svg"),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          ButtonComponent(
            text: "Continue",
            press: () async{
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                FirebaseAuth _auth = FirebaseAuth.instance;
                await _auth.sendPasswordResetEmail(email: email!);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: kPrimaryColor,
                        content: Text('Link Sent')));
                Navigator.pop(context);
              }
            },
            buttonWidth: 350,
            fontSizeLength: getProportionateScreenWidth(18),
            buttonHeight: 50,
            textColor: Colors.white,
            borderColor: Colors.transparent,
            backColor: kPrimaryColor,
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          NoAccountText(),
        ],
      ),
    );
  }
}
