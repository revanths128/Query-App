import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:question_and_answer/components/ButtonComponent.dart';
import 'package:question_and_answer/components/constants.dart';
import 'package:question_and_answer/components/header2.dart';
import 'package:question_and_answer/components/size_config.dart';
import '../../../../components/QuestionRequest.dart';
import '../../../../components/text.dart';

class Contact extends StatefulWidget {
  static String id = "Contact";
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  TextEditingController nameController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    subjectController.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Header2(text: "Contact"),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(20),
                        right: getProportionateScreenWidth(20),
                        top: getProportionateScreenHeight(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: "Name: ",
                          fontSize: 16.0,
                          colorType: Colors.black,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        QuestionRequest(
                          controller: nameController,
                          onChange: (value) {},
                          height: getProportionateScreenHeight(40),
                          width: getProportionateScreenWidth(370),
                          maxLines: 1,
                          text: 'Type your name..',
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        TextWidget(
                          text: "Subject: ",
                          fontSize: 16.0,
                          colorType: Colors.black,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        QuestionRequest(
                          controller: subjectController,
                          onChange: (value) {},
                          height: getProportionateScreenHeight(40),
                          width: getProportionateScreenWidth(370),
                          maxLines: 1,
                          text: 'Type your subject..',
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        TextWidget(
                          text: "Message: ",
                          fontSize: 16.0,
                          colorType: Colors.black,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        QuestionRequest(
                          controller: messageController,
                          onChange: (value) {},
                          height: getProportionateScreenHeight(180),
                          width: getProportionateScreenWidth(370),
                          maxLines: 10,
                          text: 'Type your doubts here...',
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ButtonComponent(
                          fontSizeLength: getProportionateScreenWidth(20),
                          buttonHeight: 50,
                          press: () async {
                            final Email email = Email(
                              body: messageController.text,
                              subject: subjectController.text,
                              recipients: ['darshanpm.cs19@bmsce.ac.in'],
                              isHTML: false,
                            );

                            await FlutterEmailSender.send(email);
                            nameController.clear();
                            subjectController.clear();
                            messageController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: kPrimaryColor,
                                content: Text('Message sent')));
                          },
                          buttonWidth: 350,
                          textColor: Colors.white,
                          borderColor: Colors.transparent,
                          backColor: kPrimaryColor,
                          text: 'Send',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
