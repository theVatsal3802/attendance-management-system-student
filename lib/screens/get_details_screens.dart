import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_container.dart';
import '../widgets/sub_heading_text.dart';
import '../helpers/space_helpers.dart';
import './dashboard_screen.dart';

class GetDetailsScreen extends StatefulWidget {
  static const routeName = "/records";
  const GetDetailsScreen({Key? key}) : super(key: key);

  @override
  State<GetDetailsScreen> createState() => _GetDetailsScreenState();
}

class _GetDetailsScreenState extends State<GetDetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String batch = "";
  final batchController = TextEditingController();

  void setBatch() async {
    if (batchController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text(
            "Please Enter the batch",
            textScaleFactor: 1,
          ),
          action: SnackBarAction(
              label: "OK",
              textColor: Colors.black,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }),
        ),
      );
      return;
    } else if (batchController.text.trim().length != 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text(
            "Batch code must be exactly 7 characters",
            textScaleFactor: 1,
          ),
          action: SnackBarAction(
              label: "OK",
              textColor: Colors.black,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }),
        ),
      );
      return;
    }
    setState(() {
      batch = batchController.text.trim().toUpperCase();
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .update({"batch": batch}).then(
      (_) => Navigator.of(context).pushReplacementNamed(
        DashBoardScreen.routeName,
        arguments: batch,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Please Enter your details",
          textScaleFactor: 1,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: height,
                width: width,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const SubHeadingText(
                        text: "Batch",
                        textSize: 24,
                      ),
                      const VerticalSizedBox(height: 10),
                      CustomContainer(
                        icon: Icons.school,
                        child: TextField(
                          controller: batchController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                              hintText:
                                  "Eg: CSE2020 for the CSE Batch of 2020"),
                        ),
                      ),
                      const VerticalSizedBox(height: 10),
                      ElevatedButton(
                        onPressed: setBatch,
                        child: const Text(
                          "Submit",
                          textScaleFactor: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
