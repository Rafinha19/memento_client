import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'carreteCard.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Perfil';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const ProfileView(),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const SERVER_IP = 'http://localhost:8080';

  Future<String?> getProfilePicture(String username) async {
    try {
      var res = await http.get(
        Uri.parse("$SERVER_IP/api/users/$username/image"),
        headers: {"Content-Type": "application/json"},
      );
      if (res.statusCode == 200) {
        return res.body;
      } else {
        return null;
      }
    } catch (e) {
      return "Connection Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30, // Image radius
                backgroundImage:
                    NetworkImage("$SERVER_IP/api/users/rafa/image"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Text("rafa",textAlign: TextAlign.left),
                    Text("2 publicaciones",textAlign: TextAlign.left)
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.orange, borderRadius: BorderRadius.circular(10)),
                child:
                TextButton(
                  onPressed: () async {},
                  child: Text(
                    'Cerrar sesion',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            child: TextButton(
              onPressed: () { },
              child: Text(
                'Editar perfil',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            child: TextButton(
              onPressed: () { },
              child: Text(
                'Lista de amigos',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
        MementoCard(),
      ],
    ));
  }
}
