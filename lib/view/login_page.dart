import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userdetails/common/commonpopup.dart';
import 'package:userdetails/model/api/api_service.dart';
import 'package:userdetails/view/homscreen.dart';
import 'package:userdetails/view/sign_up_page.dart';
import '../common/custome_loader.dart';
import '../model/provider/datanotifier.dart';

class Login_page extends StatefulWidget {
  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _emailctrl = TextEditingController();
  final _passwordctrl = TextEditingController();
  final apiservice = new ApiService();
  double? screenWidth;

  bool isEmail(String input) => EmailValidator.validate(input);
  Future<bool> _isBack() {
    return Popup().ExitAlert(context);
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      screenWidth = MediaQuery.of(context).size.width / 2.5;
    } else {
      screenWidth = MediaQuery.of(context).size.width;
    }
    return SafeArea(
      child: WillPopScope(
        onWillPop: _isBack,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1), BlendMode.lighten),
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
                        Form(
                          key: _formkey,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 20),
                                      width: screenWidth! * 0.8,
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _emailctrl,
                                        decoration: InputDecoration(
                                            hintText: "Enter Email",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              borderSide: const BorderSide(
                                                width: 5,
                                              ),
                                            ),
                                            prefixIcon: Icon(Icons.email)),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please Enter emailID";
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
                                      padding: const EdgeInsets.only(top: 20),
                                      width: screenWidth! * 0.8,
                                      child: TextFormField(
                                        controller: _passwordctrl,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                            hintText: "Enter password",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              borderSide: const BorderSide(
                                                width: 5,
                                              ),
                                            ),
                                            prefixIcon: const Icon(Icons.lock)),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please Enter Password";
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                                      String pwd = _passwordctrl.text;
                                      bool wrongPwd;
                                      if (_formkey.currentState!.validate()) {
                                        CustomUIBlock.block(context);
                                        if (pwd == 'pistol' ||
                                            pwd == "cityslicka") {
                                          wrongPwd = false;
                                        } else {
                                          wrongPwd = true;
                                        }
                                        if (_emailctrl.text ==
                                                'eve.holt@reqres.in' &&
                                            wrongPwd == true) {
                                          CustomUIBlock.unblock(context);
                                          final snackBar = SnackBar(
                                              content: Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      "Incorrect Password",
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
                                          return;
                                        }

                                        var response =
                                            await apiservice.loginUser(
                                                _emailctrl.text,
                                                _passwordctrl.text);
                                        if (response['token'] != null) {
                                          CustomUIBlock.unblock(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      ChangeNotifierProvider(
                                                        create: (context) =>
                                                            DataNotifier(),
                                                        child: HomeScreen(
                                                            _emailctrl.text),
                                                      )));
                                        } else {
                                          CustomUIBlock.unblock(context);
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
                                    child: const Text(
                                      'Log in',
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
                          padding: const EdgeInsets.only(left: 20),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 30),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: "Don't have an account?  ",
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: 'Create Account',
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.green),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _formkey.currentState?.reset();
                                        _emailctrl.clear();
                                        _passwordctrl.clear();
                                        //navigate to desired screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUpUser()),
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
      ),
    );
  }
}
