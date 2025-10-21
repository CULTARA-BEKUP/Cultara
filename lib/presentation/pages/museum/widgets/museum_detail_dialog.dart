import 'package:cultara/model/Museum.dart';
import 'package:flutter/material.dart';

void showMuseumDetailDialog(BuildContext context, Museum museum) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(museum.name, style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(museum.description, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Tutup"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
