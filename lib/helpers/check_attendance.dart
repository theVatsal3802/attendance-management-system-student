import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckAttendance {
  DocumentSnapshot<Map<String, dynamic>>? teacherData;

  Future<bool> getAttendanceData(User user, String time, String location,
      String cameraScanResult, String month) async {
    bool present = false;
    teacherData = await getTeacherData(cameraScanResult, month);
    int colon = time.indexOf(":");
    int hour = int.parse(time.substring(0, colon));
    int minute = int.parse(time.substring(colon + 1));
    String teacherTime = teacherData!.get("Attendance Started at");
    String teacherLocation = teacherData!.get("location");
    int teacherColon = teacherTime.indexOf(":");
    int teacherHour = int.parse(teacherTime.substring(0, teacherColon));
    int teacherMinute = int.parse(teacherTime.substring(teacherColon + 1));
    if (hour <= teacherHour &&
        minute <= teacherMinute &&
        location == teacherLocation) {
      present = true;
    }
    await FirebaseFirestore.instance
        .collection(cameraScanResult.substring(8, 15))
        .doc(user.email!.substring(0, 12))
        .collection("${DateTime.now().day} $month, ${DateTime.now().year}")
        .doc(cameraScanResult.substring(0, 6))
        .update(
      {
        "status": present,
      },
    );
    return present;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getTeacherData(
      String cameraScanResult, String month) async {
    return await FirebaseFirestore.instance
        .collection(cameraScanResult.substring(17))
        .doc(cameraScanResult.substring(8, 15))
        .collection("${DateTime.now().day} $month, ${DateTime.now().year}")
        .doc(cameraScanResult.substring(0, 6))
        .get();
  }
}
