import 'package:flutter/material.dart';
import 'package:memento_flutter_client/loginView.dart';
import 'package:memento_flutter_client/TabPage.dart';
import 'package:memento_flutter_client/carreteCard.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}
