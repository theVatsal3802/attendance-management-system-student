import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/space_helpers.dart';
import '../widgets/heading_text.dart';
import '../widgets/sub_heading_text.dart';
import '../widgets/custom_container.dart';
import './dashboard_screen.dart';
import './verify_email_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String name = "";
  String email = "";
  String password = "";
  bool _isLogin = true;
  bool _isLoading = false;

  void _submitForm() async {
    FocusScope.of(context).unfocus();
    bool validity = _formKey.currentState!.validate();
    if (!validity) {
      return;
    }
    _formKey.currentState!.save();
    UserCredential? userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (_isLogin) {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim().toLowerCase(),
          password: password.trim(),
        );
        Navigator.of(context).pushReplacementNamed(DashBoardScreen.routeName);
      } else {
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim().toLowerCase(),
          password: password.trim(),
        );
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(
          {
            "name": name,
            "email": email,
          },
        ).then(
          (_) => Navigator.of(context)
              .pushReplacementNamed(VerifyEmailScreen.routeName),
        );
      }
    } on FirebaseAuthException catch (error) {
      var msg = "An Error Occurred! Please Try Again";
      if (error.code == "invalid-email") {
        msg = "Invalid Email";
      } else if (error.code == "user-not-found") {
        msg = "User Not Found! Please Sign Up to Continue";
      } else if (error.code == "wrong-password") {
        msg = "The password entered by you is invalid";
      } else if (error.code == "email-already-in-use") {
        msg = "The Email entered is already in use! Login with the email";
      }
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text(
              "An Error Occurred",
              textScaleFactor: 1,
            ),
            content: Text(
              msg,
              textScaleFactor: 1,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VerticalSizedBox(
                    height: _isLogin ? height * 0.15 : height * 0.07),
                Image.asset(
                  "assets/images/logo.png",
                  height: 200,
                  width: 200,
                ),
                VerticalSizedBox(height: height * 0.02),
                HeadingText(
                  text: _isLogin ? "Login" : "Sign Up",
                  textSize: 28,
                ),
                if (!_isLogin) VerticalSizedBox(height: height * 0.02),
                if (!_isLogin)
                  const SubHeadingText(
                    text: "Name",
                    textSize: 22,
                  ),
                if (!_isLogin) VerticalSizedBox(height: height * 0.01),
                if (!_isLogin)
                  CustomContainer(
                    icon: Icons.person,
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Enter your Full Name"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter your name";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        name = value!;
                      },
                    ),
                  ),
                VerticalSizedBox(height: height * 0.02),
                const SubHeadingText(
                  text: "College Email Id",
                  textSize: 22,
                ),
                VerticalSizedBox(height: height * 0.01),
                CustomContainer(
                  icon: Icons.email,
                  child: TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Enter your College Email Id"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter your Email Id";
                      } else if (!(value.contains("@") &&
                          value.endsWith("iiitkota.ac.in"))) {
                        return "Invalid Email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                ),
                VerticalSizedBox(height: height * 0.02),
                const SubHeadingText(
                  text: "Password",
                  textSize: 22,
                ),
                VerticalSizedBox(height: height * 0.01),
                CustomContainer(
                  icon: Icons.security,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter your password";
                      } else if (value.length < 8) {
                        return "Password too short";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                    obscureText: true,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Enter your Password"),
                  ),
                ),
                VerticalSizedBox(height: height * 0.02),
                if (_isLoading) const CircularProgressIndicator.adaptive(),
                if (!_isLoading)
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      _isLogin ? "Login" : "Sign Up",
                      textScaleFactor: 1,
                    ),
                  ),
                VerticalSizedBox(height: height * 0.02),
                if (!_isLoading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? "Don't Have an account?\n Sign Up Instead"
                          : "Already have an account?\n Login Instead",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
