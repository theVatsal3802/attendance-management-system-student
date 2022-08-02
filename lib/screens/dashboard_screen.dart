import 'package:attendance_iiitkota/helpers/date_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:geolocator/geolocator.dart';

import '../widgets/custom_tab_button.dart';
import '../widgets/heading_text.dart';
import '../helpers/space_helpers.dart';
import './confirm_qr_scan_screen.dart';
import './login_screen.dart';
import '../helpers/check_attendance.dart';
import './attendance_record_screen.dart';
import './edit_profile_screen.dart';

class DashBoardScreen extends StatefulWidget {
  static const routeName = "/dashboard";
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String currentAddress = "";
  Position? currentPosition;
  String result = "";
  Map<String, String> sendData = {
    "result": "",
    "date": "",
  };

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Please Enable your device location service");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location Permission is denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Location Permission is denied forever");
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemark[0];
      setState(() {
        currentPosition = position;
        currentAddress = "${place.name}";
      });
    } catch (error) {
      Fluttertoast.showToast(msg: "Failed to get current location");
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut().then(
      (_) {
        FirebaseAuth.instance.authStateChanges().listen(
          (User? user) {
            if (user == null) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName, (route) => false);
            }
          },
        );
      },
    );
  }

  Future _scanQR(String name) async {
    try {
      String? cameraScanResult = await scanner.scan();
      setState(() {
        result = cameraScanResult!;
      });
      String month = DateHelper().setMonth(DateTime.now().month.toString());
      String teacherName = cameraScanResult!.substring(17);
      String subject = cameraScanResult.substring(0, 6);
      String batch = cameraScanResult.substring(8, 15);
      final userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();
      await _determinePosition();
      await FirebaseFirestore.instance
          .collection(batch)
          .doc(user!.email!.substring(0, 12))
          .collection("${DateTime.now().day} $month, ${DateTime.now().year}")
          .doc(subject)
          .set(
        {
          "name": userData["name"],
          "date":
              "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
          "teacher": teacherName,
          "location": currentAddress,
          "marked at": "${DateTime.now().hour}:${DateTime.now().minute}",
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Failed to Mark attendance",
            textScaleFactor: 1,
          ),
          action: SnackBarAction(
            label: "OK",
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } finally {
      String month = DateHelper().setMonth(DateTime.now().month.toString());
      await CheckAttendance()
          .getAttendanceData(
        user!,
        "${DateTime.now().hour}:${DateTime.now().minute}",
        currentAddress,
        result,
        month,
      )
          .then(
        (_) {
          Navigator.of(context).pushNamed(
            ConfirmQRScanScreen.routeName,
            arguments: result,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Welcome",
              textScaleFactor: 1,
            ),
            actions: [
              IconButton(
                tooltip: "Logout",
                onPressed: signOut,
                icon: const Icon(
                  Icons.logout,
                ),
              ),
            ],
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
                        HeadingText(
                          text: "Hello, ${snapshot.data!["name"]}",
                          textSize: 32,
                        ),
                        VerticalSizedBox(height: height * 0.02),
                        CustomTabButton(
                          onTap: () {
                            _scanQR(snapshot.data!["name"]);
                          },
                          icon: Icons.qr_code_scanner,
                          child: Text(
                            "Mark Attendance",
                            textScaleFactor: 1,
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .fontSize,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        VerticalSizedBox(height: height * 0.05),
                        CustomTabButton(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AttendanceRecordScreen.routeName);
                          },
                          icon: Icons.stacked_bar_chart,
                          child: Text(
                            "See Attendance Record",
                            textScaleFactor: 1,
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .fontSize,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        VerticalSizedBox(height: height * 0.05),
                        CustomTabButton(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(EditProfileScreen.routeName);
                          },
                          icon: Icons.edit,
                          child: Text(
                            "Edit Profile",
                            textScaleFactor: 1,
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .fontSize,
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
      },
    );
  }
}
