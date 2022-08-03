import 'package:flutter/material.dart';

import '../widgets/custom_tab_button.dart';
import '../helpers/space_helpers.dart';
import '../widgets/custom_container.dart';
import './all_subject_screen.dart';
import './some_subject_screen.dart';

class AttendanceRecordScreen extends StatefulWidget {
  static const routeName = "/see-record";
  const AttendanceRecordScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceRecordScreen> createState() => _AttendanceRecordScreenState();
}

class _AttendanceRecordScreenState extends State<AttendanceRecordScreen> {
  String subject = "";

  Future<String> enterSubject(BuildContext context) async {
    final controller = TextEditingController();
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Enter the subject",
                      textScaleFactor: 1,
                    ),
                  ),
                  const VerticalSizedBox(height: 5),
                  CustomContainer(
                    icon: Icons.book,
                    child: TextField(
                      controller: controller,
                      textCapitalization: TextCapitalization.characters,
                      enableSuggestions: true,
                      autocorrect: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Enter the subject Code",
                      ),
                    ),
                  ),
                  const VerticalSizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (controller.text.isNotEmpty) {
                        setState(() {
                          subject = controller.text.trim().toUpperCase();
                        });
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 2),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            content: const Text(
                              "Please Enter a Subject before proceeding",
                              textScaleFactor: 1,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Submit Subject",
                      textScaleFactor: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    return controller.text.trim().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "See Attendance Records",
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
            SizedBox(
              height: height,
              width: width,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CustomTabButton(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AllSubjectScreen.routeName);
                      },
                      icon: Icons.subject,
                      child: Text(
                        "Attendance Record for all subjects",
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline6!.fontSize,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    VerticalSizedBox(height: height * 0.05),
                    CustomTabButton(
                      onTap: () async {
                        try {
                          String sub = await enterSubject(context);
                          setState(() {
                            subject = sub;
                          });
                          if (subject.isEmpty) {
                            return;
                          }
                        } finally {
                          if (subject.isNotEmpty) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SomeSubjectScreen(
                                    subject: subject,
                                  );
                                },
                              ),
                            );
                          }
                        }
                      },
                      icon: Icons.book,
                      child: Text(
                        "Attendance Record for specific subject",
                        textScaleFactor: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline6!.fontSize,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
