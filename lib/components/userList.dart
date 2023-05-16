import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Model/usuario.dart';
import 'package:memento_flutter_client/components/myAmigos.dart';
import 'package:memento_flutter_client/Config/Properties.dart';
import 'package:memento_flutter_client/components/userCard.dart';
import 'package:memento_flutter_client/repository/UsersRepository.dart';

import '../Model/amigo.dart';
import '../Model/carrete.dart';

class userList extends StatefulWidget {
  @override
  _userListState createState() => _userListState();
}

class _userListState extends State<userList> {
  late Future<List<Amigo>> futureUserList;

  @override
  void initState() {
    super.initState();
    futureUserList = UsersRepository().getUsuariosNoAmigos();
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
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                    child: Text("User list",style: TextStyle(color: Colors.white, fontSize: 18),),
                  ),
                  FutureBuilder<List<Amigo>>(
                    future: futureUserList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Amigo> usuarios = snapshot.data!;
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: usuarios.length,
                            itemBuilder: (context, index) {
                              final usuario = usuarios[index];
                              return SizedBox(
                                height: 90,
                                width: double.infinity,
                                child: userCard(usuario: usuario, ismyAmigo: false,),
                              );
                            }
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
