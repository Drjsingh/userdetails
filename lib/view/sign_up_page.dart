import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:userdetails/model/api/api_service.dart';
import 'package:userdetails/view/login_page.dart';

import '../common/commonpopup.dart';

class SignUpUser extends StatefulWidget {
  @override
  State<SignUpUser> createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _emailctrl = TextEditingController();
  final _pwdctrl = TextEditingController();
  final _verifypwdilctrl = TextEditingController();
  String pwd = '';
  String verifypwd = '';
  bool showIcon = false;
  bool checklength = false;
  double? screenWidth;
  final apiservice = ApiService();
  bool isEmail(String input) => EmailValidator.validate(input);
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      screenWidth = MediaQuery.of(context).size.width / 2.5;
    } else {
      screenWidth = MediaQuery.of(context).size.width;
    }
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("asset/mob1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: screenWidth,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: const Image(
                          image: AssetImage('asset/logo.jpeg'),
                          height: 100,
                          width: 100,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Create an Account",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 20),
                                  width: screenWidth! * 0.8,
                                  child: TextFormField(
                                    controller: _emailctrl,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                        hintText: "Email",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          borderSide: BorderSide(
                                            width: 5,
                                          ),
                                        ),
                                        prefixIcon: Icon(Icons.email)),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter Email";
                                      }
                                      if (!isEmail(value)) {
                                        return "Enter valid Email";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 20),
                                  width: screenWidth! * 0.8,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        pwd = value;
                                        if (pwd == verifypwd) {
                                          showIcon = true;
                                        } else {
                                          showIcon = false;
                                        }
                                      });
                                    },
                                    controller: _pwdctrl,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          borderSide: BorderSide(
                                            width: 5,
                                          ),
                                        ),
                                        prefixIcon: Icon(Icons.lock)),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter Password";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 20),
                                  width: screenWidth! * 0.8,
                                  child: TextFormField(
                                    onChanged: (val) {
                                      setState(() {
                                        verifypwd = val;
                                        if (val.length > 3) {
                                          checklength = true;
                                        } else {
                                          checklength = false;
                                        }
                                        if (val == pwd) {
                                          showIcon = true;
                                        } else {
                                          showIcon = false;
                                        }
                                      });
                                    },
                                    controller: _verifypwdilctrl,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                        hintText: "Verify password",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          borderSide: const BorderSide(
                                            width: 5,
                                          ),
                                        ),
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: (showIcon)
                                            ? const Icon(
                                                Icons.verified_outlined,
                                                color: Colors.green,
                                              )
                                            : (showIcon == false &&
                                                    checklength == true)
                                                ? const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  )
                                                : const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  )),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please verify Password";
                                      }
                                      if (value != pwd) {
                                        return "password is not matching";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: screenWidth! * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: MaterialButton(
                                  onPressed: () async {
                                    if (_formkey.currentState!.validate()) {
                                      var response =
                                          await apiservice.registerUser(
                                              _emailctrl.text,
                                              _verifypwdilctrl.text);
                                      print("ressponse---------$response");
                                      if (response['token'] != null) {
                                        Popup().RegisterSuccessfully(context);
                                      } else {
                                        final snackBar = SnackBar(
                                            content: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    response['error'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            duration:
                                                const Duration(seconds: 3),
                                            backgroundColor: Colors.red);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 30),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '<<-- Back to Login Page ',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login_page()),
                                      );
                                    }),
                            ],
                          ),
                          textScaleFactor: 0.5,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
