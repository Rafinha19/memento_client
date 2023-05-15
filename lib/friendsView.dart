import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/components/myAmigos.dart';
import 'package:memento_flutter_client/Config/Properties.dart';
import 'package:memento_flutter_client/components/userList.dart';

class friendsView extends StatefulWidget {
  @override
  _friendsViewState createState() => _friendsViewState();
}

class _friendsViewState extends State<friendsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Memento',
            style: TextStyle(fontSize: 26),
          ),
          backgroundColor: AppbackgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 18.0, right: 12.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => userList()
                            )
                        );
                      },
                      child: Text(
                        "Añadir amigos",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
                    child: Text("Friends List",style: TextStyle(color: Colors.white, fontSize: 18),),
                  ),
                  myAmigos()
                ],
              ),
            ),
          ),
        ));
  }
}
