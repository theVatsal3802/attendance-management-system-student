import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckAttendance {
  DocumentSnapshot<Map<String, dynamic>>? teacherData;

  Future<bool> getAttendanceData(User user, String time, String location,
      String cameraScanResult, String month) async {
    bool present = false;
    await getTeacherData(cameraScanResult, month);
    int hour = int.parse(time.substring(0, 2));
    int minute = int.parse(time.substring(3, 5));
    String teacherTime = await teacherData!.get("Attendance Started at");
    String teacherLocation = await teacherData!.get("location");
    int teacherHour = int.parse(teacherTime.substring(0, 2));
    int teacherMinute = int.parse(teacherTime.substring(3, 5));
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

  Future<void> getTeacherData(String cameraScanResult, String month) async {
    teacherData = await FirebaseFirestore.instance
        .collection(cameraScanResult.substring(17))
        .doc(cameraScanResult.substring(8, 15))
        .collection("${DateTime.now().day} $month, ${DateTime.now().year}")
        .doc(cameraScanResult.substring(0, 6))
        .get();
  }
}
