import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:memento_flutter_client/gptCarreteCard.dart';
import 'dart:convert';
import 'Model/carrete.dart';
import 'package:memento_flutter_client/Config/Properties.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Carrete? _carrete;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getMyLastCarrete();
  }

  Future<Carrete?> getMyLastCarrete() async {
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    String token = jsonData['token'];
    try {
      var res = await http.get(
        Uri.parse("$SERVER_IP/api/carretes/mylastcarrete"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token', //'bearer token'
        },
      );
      if (res.statusCode == 200) {
        setState(() {
          _carrete = Carrete.fromJson(jsonDecode(res.body));
        });
      } else {
        setState(() {
          _carrete = null;
        });
      }
    } catch (e) {
      //return "Connection Error";
      setState(() {
        _carrete = null;
      });
      debugPrint('Connection error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
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
                    Text("rafa", textAlign: TextAlign.left),
                    Text("2 publicaciones", textAlign: TextAlign.left)
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
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
              onPressed: () {},
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
              onPressed: () {},
              child: Text(
                'Lista de amigos',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
        _carrete != null
            ? CarreteCard(carrete: _carrete!)
            : CircularProgressIndicator()
      ],
    )));
  }
}
