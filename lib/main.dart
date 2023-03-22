import 'dart:convert' show json, base64, ascii;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter_client/loginView.dart';
import 'package:memento_flutter_client/TabPage.dart';

final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
      ),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return CircularProgressIndicator();
            if(snapshot.data != "") {
              var str = snapshot.data.toString();
              var jwt = str.split(".");


              if(jwt.length !=3) {
                return LoginView();
              } else {
                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                  return TabPage(str, payload);
                } else {
                  return LoginView();
                }
              }
            } else {
              return LoginView();
            }
          }
      ),
    );
  }
}