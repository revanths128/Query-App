import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:question_and_answer/components/ButtonComponent.dart';
import 'package:question_and_answer/components/constants.dart';
import 'package:question_and_answer/components/profile_pic.dart';
import 'package:question_and_answer/components/size_config.dart';
import 'package:question_and_answer/screens/authenticate/components/build_form_field.dart';
import 'package:question_and_answer/screens/authenticate/components/form_error.dart';
import 'package:question_and_answer/screens/authenticate/components/keyboard.dart';
import 'package:question_and_answer/screens/authenticate/register/drop_down_widget.dart';
import 'package:question_and_answer/screens/services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../start.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? email;
  String? password;
  String? conformPassword;
  String? filePath;
  String? fileName;
  FilePickerResult? image;
  File? fileType;
  bool remember = false;
  final List<String?> errors = [];
  final List<String> designationRoles = [
    'Student',
    'Teacher',
  ];

  final List<String> departments = [
    'Computer Science and Engineering',
    'Information Science and Engineering',
  ];

  String? selectedDesignatedValue;
  String? selectedDepartment;

  final AuthService _auth = AuthService();

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
          ProfilePic(
            onPress: () async {
              await getImage();
            },
            image: image != null ? CircleAvatar(backgroundImage: FileImage(fileType!),) : CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile.jpg"),
            )
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          BuildFormField(
            obscure: false,
            onSave: (newValue) => username = newValue,
            validate: (value) {
              if (value!.isEmpty) {
                addError(error: kNameNullError);
                return " ";
              }
              return null;
            },
            onChange: (value) {
              if (value.isNotEmpty) {
                removeError(error: kNameNullError);
              }
              return null;
            },
            label: "Username",
            hint: 'Enter your name',
            image: 'assets/icons/User.svg',
          ),
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
          BuildFormField(
            obscure: true,
            onSave: (newValue) => conformPassword = newValue,
            validate: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if ((password != value)) {
                addError(error: kMatchPassError);
                return "";
              }
              return null;
            },
            onChange: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.isNotEmpty && password == conformPassword) {
                removeError(error: kMatchPassError);
              }
              conformPassword = value;
            },
            label: "Confirm Password",
            hint: "Re-enter your password",
            image: "assets/icons/Lock.svg",
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          DropDownWidget(
            hintText: 'Select your designation',
            validate: (value) {
              if (value == null) {
                addError(error: 'Please select designation');
                return '';
              }
            },
            designationRoles: designationRoles,
            onChange: (value) {
              selectedDesignatedValue = value.toString();
            },
            label: 'Designation',
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          DropDownWidget(
            hintText: 'Select your department',
            validate: (value) {
              if (value == null) {
                addError(error: 'Please select department');
                return '';
              }
            },
            designationRoles: departments,
            onChange: (value) {
              selectedDepartment = value.toString();
            },
            label: 'Department',
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          ButtonComponent(
            text: "Register",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                KeyboardUtil.hideKeyboard(context);

                dynamic result = await _auth.registerWithEmailAndPassword(
                  email!,
                  password!,
                  username!,
                  selectedDesignatedValue!,
                  selectedDepartment!,
                );
                if (result == null) {
                  addError(error: "Enter a valid email");
                } else {
                  await uploadImage();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: kPrimaryColor,
                      content: Text('Account created')));
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
          SizedBox(height: getProportionateScreenHeight(30)),
        ],
      ),
    );
  }

  getImage() async {
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      {
        var result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['png', 'jpg']);
        setState(() {
          image = result;
          filePath = image!.files.single.path;
          fileType = File(filePath!);
        });
        if (image == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No file selected')));
        }
      }
    }
  }

  uploadImage() async {
    if (image != null) {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      fileName = _auth.currentUser!.uid;
      filePath = image!.files.single.path;
      final FirebaseStorage storage = FirebaseStorage.instance;
      File file = File(filePath!);
      await storage.ref('test/$fileName').putFile(file);
    }
  }
}
