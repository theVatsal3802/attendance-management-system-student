import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/date_helper.dart';
import '../widgets/sub_heading_text.dart';
import './dashboard_screen.dart';

class SomeSubjectScreen extends StatefulWidget {
  final String subject;
  const SomeSubjectScreen({required this.subject, Key? key}) : super(key: key);

  @override
  State<SomeSubjectScreen> createState() => _SomeSubjectScreenState();
}

class _SomeSubjectScreenState extends State<SomeSubjectScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String batch = "";
  String selectedDate = "";
  Future<DocumentSnapshot<Map<String, dynamic>>>? userData;
  late Future<bool> exists;

  Future<bool> checkExistence() async {
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    final document = await FirebaseFirestore.instance
        .collection(userData["batch"])
        .doc(user!.email!.substring(0, 12))
        .collection(selectedDate)
        .get();
    if (document.docs.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "No Attendance Taken on specified day",
              textScaleFactor: 1,
            ),
            content: const Text("Please change the date and try again"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      DashBoardScreen.routeName, (route) => false);
                },
                child: const Text(
                  "OK",
                  textScaleFactor: 1,
                ),
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final result = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    return result;
  }

  @override
  void initState() {
    super.initState();
    userData = getUserData();
  }

  void setDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      String day = date.day.toString();
      String month = DateHelper().setMonth(date.month.toString());
      String year = date.year.toString();
      setState(() {
        selectedDate = "$day $month, $year";
      });
    }
    setState(() {
      exists = checkExistence();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subject,
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
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: userData,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (selectedDate.isEmpty) {
                  return SizedBox(
                    height: height,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            selectedDate.isEmpty ? "Select a Date" : "Date",
                            textScaleFactor: 1,
                          ),
                          subtitle: Text(
                            selectedDate.isEmpty
                                ? "No Date Selected"
                                : "Selected Date: $selectedDate",
                            textScaleFactor: 1,
                          ),
                          trailing: ElevatedButton(
                            onPressed: setDate,
                            child: const Text(
                              "Select Date",
                              textScaleFactor: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return FutureBuilder(
                  future: exists,
                  builder: (context, checksnapshot) {
                  if (checksnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  if (checksnapshot.data == false) {
                    return const Center();
                  }
                  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection(snapshot.data!["batch"])
                        .doc(user!.email!.substring(0, 12))
                        .collection(selectedDate)
                        .doc(widget.subject)
                        .snapshots(),
                    builder: (context, subSnapshot) {
                      if (subSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: height,
                          width: width,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  selectedDate.isEmpty
                                      ? "Select a Date"
                                      : "Date",
                                  textScaleFactor: 1,
                                ),
                                subtitle: Text(
                                  selectedDate.isEmpty
                                      ? "No Date Selected"
                                      : "Selected Date: $selectedDate",
                                  textScaleFactor: 1,
                                ),
                                trailing: IconButton(
                                  onPressed: setDate,
                                  icon: const Icon(Icons.calendar_month),
                                ),
                              ),
                              const Divider(),
                              FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SubHeadingText(
                                      text: "Attendance Status:",
                                      textSize: 20,
                                    ),
                                    Chip(
                                      backgroundColor:
                                          subSnapshot.data!["status"]
                                              ? Colors.green[200]
                                              : Colors.red[200],
                                      label: Text(
                                        subSnapshot.data!["status"]
                                            ? "Present"
                                            : "Absent",
                                        textScaleFactor: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SubHeadingText(
                                      text: "Location:",
                                      textSize: 20,
                                    ),
                                    Chip(
                                      backgroundColor:
                                          subSnapshot.data!["status"]
                                              ? Colors.green[200]
                                              : Colors.red[200],
                                      label: Text(
                                        subSnapshot.data!["location"],
                                        textScaleFactor: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SubHeadingText(
                                      text:
                                          "Attendance Sent for evaluation at:",
                                      textSize: 20,
                                    ),
                                    Chip(
                                      backgroundColor:
                                          subSnapshot.data!["status"]
                                              ? Colors.green[200]
                                              : Colors.red[200],
                                      label: Text(
                                        subSnapshot.data!["marked at"],
                                        textScaleFactor: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SubHeadingText(
                                      text: "Attendance Taken By:",
                                      textSize: 20,
                                    ),
                                    Chip(
                                      backgroundColor:
                                          subSnapshot.data!["status"]
                                              ? Colors.green[200]
                                              : Colors.red[200],
                                      label: Text(
                                        subSnapshot.data!["teacher"],
                                        textScaleFactor: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
