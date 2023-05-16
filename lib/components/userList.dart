import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Model/currentUsuarioData.dart';
import 'package:memento_flutter_client/components/myAmigos.dart';
import 'package:memento_flutter_client/Config/Properties.dart';
import 'package:memento_flutter_client/components/userCard.dart';
import 'package:memento_flutter_client/repository/UsersRepository.dart';
import 'package:provider/provider.dart';

import '../Controller/usuarioList_provider.dart';
import '../Model/usuario.dart';
import '../Model/carrete.dart';

class userList extends StatefulWidget {
  @override
  _userListState createState() => _userListState();
}

class _userListState extends State<userList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UsuarioList_provider usuarioList_provider= Provider.of<UsuarioList_provider>(context, listen: true);

    Future refresh() async {
      usuarioList_provider.getUsuariosNoAmigos();
      setState(() {

      });
    }

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
          child: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            onRefresh: refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: Text("User list",style: TextStyle(color: Colors.white, fontSize: 20),),
                    ),
                    usuarioList_provider.isLoading?
                        const CircularProgressIndicator()
                        :
                    usuarioList_provider.usuariosNoamigos.length==0?
                    Text("Eres amigo de todos los usuarios actuales")
                        :
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: usuarioList_provider.usuariosNoamigos.length,
                        itemBuilder: (context, index) {
                          final usuario = usuarioList_provider.usuariosNoamigos[index];
                          return SizedBox(
                            height: 90,
                            width: double.infinity,
                            child: userCard(usuario: usuario, ismyAmigo: false,),
                          );
                        }
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
