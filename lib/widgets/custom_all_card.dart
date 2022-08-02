import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomAllCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  const CustomAllCard({required this.doc, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: doc["status"] ? Colors.green[200] : Colors.red[200],
      elevation: 10,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: doc["status"] ? Colors.green : Colors.red,
          child:
              doc["status"] ? const Icon(Icons.check) : const Icon(Icons.clear),
        ),
        title: Text(
          doc.id,
          textScaleFactor: 1,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          doc["status"] ? "Status: Present" : "Status: Absent",
          textScaleFactor: 1,
        ),
        trailing: Chip(
          label: Text(
            "Evaluated At: ${doc["marked at"]}",
            textScaleFactor: 1,
          ),
        ),
      ),
    );
  }
}
