import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Model/carrete_provider.dart';
import 'package:memento_flutter_client/Model/usuario.dart';
import 'package:memento_flutter_client/Model/usuario_provider.dart';
import 'package:memento_flutter_client/components/myCarretes.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/components/carreteCard.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    super.initState();
    Usuario_provider usuario_provider =Provider.of<Usuario_provider>(context, listen: false);
    usuario_provider.loadUserData();
    Carrete_provider carrete_provider = Provider.of<Carrete_provider>(context, listen: false);
    carrete_provider.getMyCarretes();
  }


  @override
  Widget build(BuildContext context) {
    Usuario_provider usuario_provider =
        Provider.of<Usuario_provider>(context);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    usuario_provider.isLoading
                        ?
                        //true
                        const CircularProgressIndicator()
                        : CircleAvatar(
                            radius: 40, // Image radius
                            backgroundImage:
                                NetworkImage(usuario_provider.usuario.url_foto_perfil),
                          ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child:
                          usuario_provider.isLoading
                          ?
                          //true
                          const CircularProgressIndicator()
                          :
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Text(usuario_provider.usuario.nombre_usuario, textAlign: TextAlign.left),
                          usuario_provider.usuario.num_carretes==1 ?
                          Text(usuario_provider.usuario.num_carretes.toString() + " carrete", textAlign: TextAlign.left):
                          Text(usuario_provider.usuario.num_carretes.toString() + " carretes", textAlign: TextAlign.left)
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginView()));
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

              myCarretes()
            ],
          ),
        ),
      ),
    ));
  }
}
