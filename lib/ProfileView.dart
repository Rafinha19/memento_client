import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/myCarretes.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/carreteCard.dart';
import 'dart:convert';
import 'Model/carrete.dart';
import 'package:memento_flutter_client/Config/Properties.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'loginView.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<Carrete> futureMyLastCarrete;

  @override
  void initState() {
    super.initState();
    futureMyLastCarrete = CarreteRepository().getMyLastCarrete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 40, // Image radius
                          backgroundImage:
                          NetworkImage("$SERVER_IP/api/users/rafa/image"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                              AppLocalizations.of(context)!.sign_out,
                              style: TextStyle(color: Colors.white, fontSize: 15),
                              textAlign: TextAlign.center,
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
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          AppLocalizations.of(context)!.editProfile,
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
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(10)),
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
                    child: FutureBuilder<Carrete>(
                        future: futureMyLastCarrete,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            //return CarreteCard(carrete: snapshot.data!);
                            return carreteCard(carrete: snapshot.data!, ismyLastcarrete: true);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Expanded(
                      child: myCarretes(),
                    ),
                  ),
                ],
              ),
          ),
        )
    );
  }
}
