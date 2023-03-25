import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:memento_flutter_client/gptCarreteCard.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/carreteCard.dart';
import 'dart:convert';
import 'Model/carrete.dart';
import 'package:memento_flutter_client/Config/Properties.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';

import 'loginView.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Carrete> futureCarrete;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    futureCarrete = CarreteRepository().getMyLastCarrete();
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    Text("4 publicaciones", textAlign: TextAlign.left)
                  ],
                ),
              ),
              Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: () async {
                    AccountRepository().logOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginView()));
                  },
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
            height: 35,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey[700], borderRadius: BorderRadius.circular(10)),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Editar perfil',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: 35,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey[700], borderRadius: BorderRadius.circular(10)),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Lista de amigos',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child:FutureBuilder <Carrete>(
                  future: futureCarrete,
                  builder: (context,snapshot){
                    if (snapshot.hasData) {
                      //return CarreteCard(carrete: snapshot.data!);
                      return carreteCard(carrete: snapshot.data!);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  }
              )
              ,
            ),

        
        ],
    )));
  }
}
