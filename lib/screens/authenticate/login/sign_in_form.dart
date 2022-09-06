import 'package:flutter/material.dart';
import 'package:question_and_answer/components/ButtonComponent.dart';
import 'package:question_and_answer/components/constants.dart';
import 'package:question_and_answer/components/size_config.dart';
import 'package:question_and_answer/screens/authenticate/components/build_form_field.dart';
import 'package:question_and_answer/screens/authenticate/components/form_error.dart';
import 'package:question_and_answer/screens/authenticate/components/keyboard.dart';
import 'package:question_and_answer/screens/authenticate/login/forgot_password.dart';
import 'package:question_and_answer/screens/services/auth.dart';

import '../../start.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];
  AuthService _auth = AuthService();

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(30)),
          BuildFormField(
            obscure: false,
            onSave: (newValue) => email = newValue,
            validate: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              }
              return null;
            },
            onChange: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
              return null;
            },
            label: "Email",
            hint: 'Enter your email',
            image: 'assets/icons/Mail.svg',
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          BuildFormField(
            obscure: true,
            onSave: (newValue) => password = newValue,
            validate: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if (value.length < 8) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            onChange: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              password = value;
            },
            label: "Password",
            hint: "Enter your password",
            image: "assets/icons/Lock.svg",
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, ForgotPassword.id),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: kPrimaryColor),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          ButtonComponent(
            text: "Login",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                KeyboardUtil.hideKeyboard(context);
                dynamic result =
                    await _auth.signInWithEmailAndPassword(email!, password!);
                if (result == null) {
                  addError(error: "Invalid user credentials");
                } else {
                  Navigator.pushNamed(context, Start.id);
                }
              }
            },
            buttonWidth: 350,
            fontSizeLength: 20,
            buttonHeight: 50,
            textColor: Colors.white,
            borderColor: Colors.transparent,
            backColor: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}
