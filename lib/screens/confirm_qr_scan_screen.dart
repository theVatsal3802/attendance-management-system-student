import 'package:flutter/material.dart';

import '../helpers/space_helpers.dart';
import './dashboard_screen.dart';

class ConfirmQRScanScreen extends StatelessWidget {
  static const routeName = "/confirm";
  const ConfirmQRScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final barcodeData = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/confirm.gif",
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
              ),
              Text(
                "Attendance for ${barcodeData.substring(0, 6)} sent for evaluation successfully",
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline5!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Teacher Name: ${barcodeData.substring(17)}",
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                "Batch Name: ${barcodeData.substring(8, 15)}",
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.headline6,
              ),
              const VerticalSizedBox(
                height: 100,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      DashBoardScreen.routeName, (route) => false);
                },
                icon: const Icon(Icons.home),
                label: const Text(
                  "Return to DashBoard",
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
