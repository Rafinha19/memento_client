import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void displayDialog(BuildContext context, String title, String text) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Text(
            title,
            style: TextStyle(color: Colors.orange),
          ),
          content: Text(text)),
    );