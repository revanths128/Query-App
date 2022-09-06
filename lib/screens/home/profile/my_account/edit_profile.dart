import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:question_and_answer/components/ButtonComponent.dart';
import 'package:question_and_answer/components/constants.dart';
import 'package:question_and_answer/components/header2.dart';
import 'package:question_and_answer/components/profile_pic.dart';
import 'package:question_and_answer/components/size_config.dart';
import 'package:question_and_answer/components/text.dart';
import 'package:question_and_answer/models/user_model/database.dart';
import 'package:question_and_answer/screens/authenticate/components/build_form_field.dart';
import 'package:question_and_answer/screens/authenticate/components/form_error.dart';
import 'package:question_and_answer/screens/authenticate/components/keyboard.dart';
import 'package:question_and_answer/screens/authenticate/register/drop_down_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:question_and_answer/screens/home/profile/my_account/my_account.dart';

class EditProfile extends StatefulWidget {
  static String id = "edit_profile";

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseStorage storage = FirebaseStorage.instance;
  TextEditingController username = TextEditingController();
  String selectedDesignatedValue = "";
  String selectedDepartment = "";
  String? url;
  String? filePath;
  String? fileName;
  FilePickerResult? image;
  File? fileType;
  bool remember = false;
  bool loadData = true;
  final List<String?> errors = [];
  final List<String> designationRoles = [
    'Student',
    'Teacher',
  ];

  final List<String> departments = [
    'Computer Science and Engineering',
    'Information Science and Engineering',
  ];

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
  void initState() {
    super.initState();
    getUserData();
  }

  Future getUserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      username.text = value.data()!['username'];
      selectedDesignatedValue = value.data()!['designation'];
      selectedDepartment = value.data()!['department'];
    });
    url = await storage.ref('test/${user!.uid}').getDownloadURL();
    if(mounted){
      setState(() {
        loadData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: !loadData
            ? SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                    children: [
                      Header2(text: "Edit Profile"),
                      SizedBox(height: SizeConfig.screenHeight * 0.08), // 4%
                      TextWidget(
                        text: "Edit Profile",
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(26),
                        colorType: Colors.black,
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                      TextWidget(
                        text: "Edit your details",
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w400,
                        fontSize: getProportionateScreenWidth(15),
                        colorType: Colors.black,
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.04),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.only(left: getProportionateScreenWidth(20), right: getProportionateScreenWidth(20)),
                          child: Column(
                            children: [
                              ProfilePic(
                                onPress: () async {
                                  await getImage();
                                  setState(() {
                                    url = null;
                                  });
                                },
                                image: url != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(url!),
                                      )
                                    : (image != null
                                        ? CircleAvatar(
                                            backgroundImage: FileImage(fileType!),
                                          )
                                        : CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/images/profile.jpg"),
                                          )),
                              ),
                              SizedBox(height: getProportionateScreenHeight(30)),
                              BuildFormField(
                                controller: username,
                                obscure: false,
                                onSave: (value) {},
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    addError(error: kNameNullError);
                                    return "";
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
                              DropDownWidget(
                                value: selectedDesignatedValue,
                                hintText: 'Select your designation',
                                validate: (value) {
                                  if (value == null) {
                                    addError(error: 'Please select designation');
                                    return '';
                                  }
                                },
                                designationRoles: designationRoles,
                                onChange: (value) {
                                    setState(() {
                                      selectedDesignatedValue = value.toString();
                                    });
                                },
                                label: 'Designation',
                              ),
                              SizedBox(height: getProportionateScreenHeight(30)),
                              DropDownWidget(
                                value: selectedDepartment,
                                hintText: 'Select your department',
                                validate: (value) {
                                  if (value == null) {
                                    addError(error: 'Please select department');
                                    return '';
                                  }
                                },
                                designationRoles: departments,
                                onChange: (value) {
                                  setState(() {
                                    selectedDepartment = value.toString();
                                  });
                                },
                                label: 'Department',
                              ),
                              SizedBox(height: getProportionateScreenHeight(30)),
                              FormError(errors: errors),
                              SizedBox(height: getProportionateScreenHeight(30)),
                              ButtonComponent(
                                text: "Edit",
                                press: () async {
                                  if (_formKey.currentState!.validate()) {
                                    KeyboardUtil.hideKeyboard(context);
                                    var service = DatabaseUserService();
                                    print(selectedDesignatedValue);
                                    await service.editUserData(username.text, selectedDesignatedValue, selectedDepartment);
                                    await uploadImage();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: kPrimaryColor,
                                            content: Text('Profile edited.')));
                                    Navigator.pushNamed(context, MyAccount.id);
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
                        ),
                      ),
                    ],
                  ),
              ),
            )
            : Center(
                child: CircularProgressIndicator(),
              ),
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
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('No file selected')));
        }
      }
    }
  }

  Future<void> uploadImage() async {
    if (image != null) {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      fileName = _auth.currentUser!.uid;
      filePath = image!.files.single.path;
      final FirebaseStorage storage = FirebaseStorage.instance;
      File file = File(filePath!);
      await storage.ref('test/$fileName').putFile(file);
      var downloadUrl = await storage.ref('test/$fileName').getDownloadURL();
      setState(() {
        url = downloadUrl;
      });
    }
  }
}
