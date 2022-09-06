import 'package:flutter/material.dart';
import 'package:question_and_answer/components/ButtonComponent.dart';
import 'package:question_and_answer/components/constants.dart';
import 'package:question_and_answer/components/size_config.dart';
import 'package:question_and_answer/components/text.dart';
import 'package:question_and_answer/screens/authenticate/login/login.dart';
import 'package:question_and_answer/screens/authenticate/register/register.dart';

class Welcome extends StatelessWidget {
  static String id = "welcome";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  child: Column(
                    children: <Widget>[
                      Spacer(flex: 1),
                      TextWidget(
                        text: "QUERY",
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        colorType: kPrimaryColor,
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      TextWidget(
                        text:
                            "Welcome to Query, We'll find answers to your questions",
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        colorType: Colors.black,
                        textAlign: TextAlign.center,
                      ),
                      Spacer(flex: 1),
                      Image.asset(
                        "assets/images/query.png",
                        height: getProportionateScreenHeight(350),
                        width: getProportionateScreenWidth(335),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ButtonComponent(
                        text: "Login",
                        buttonWidth: 100.0,
                        buttonHeight: 50.0,
                        fontSizeLength: 20.0,
                        textColor: Colors.white,
                        borderColor: Colors.transparent,
                        backColor: kPrimaryColor,
                        press: () {
                          Navigator.pushNamed(context, Login.id);
                        },
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(20),
                      ),
                      ButtonComponent(
                        text: "Register",
                        buttonWidth: 100.0,
                        buttonHeight: 50.0,
                        fontSizeLength: 20.0,
                        textColor: Colors.white,
                        borderColor: Colors.transparent,
                        backColor: kPrimaryColor,
                        press: () {
                          Navigator.pushNamed(context, Register.id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
