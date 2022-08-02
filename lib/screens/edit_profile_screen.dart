import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_container.dart';
import '../helpers/space_helpers.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = "/edit";
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final controller = TextEditingController();

  void _editForm() async {
    try {
      FocusScope.of(context).unfocus();
      if (controller.text.isEmpty) {
        return;
      }
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update(
        {
          "name": controller.text.trim(),
        },
      ).then(
        (_) {
          Navigator.of(context).pop();
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text(
            "An error occurred! Please try again",
            textScaleFactor: 1,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Name",
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: height,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const VerticalSizedBox(height: 30),
                    CustomContainer(
                      icon: Icons.person,
                      child: TextField(
                        controller: controller,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: true,
                        autocorrect: true,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                            hintText: "Enter New name"),
                      ),
                    ),
                    const VerticalSizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _editForm,
                      child: const Text(
                        "Edit Name",
                        textScaleFactor: 1,
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
