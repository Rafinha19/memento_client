import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Controller/friendsCarretes_provider.dart';
import 'package:memento_flutter_client/Controller/solicitudAmistad_provider.dart';
import 'package:memento_flutter_client/Controller/usuarioList_provider.dart';
import 'package:memento_flutter_client/components/myAmigos.dart';
import 'package:memento_flutter_client/Config/Properties.dart';
import 'package:memento_flutter_client/components/mySolicitudesAmistad.dart';
import 'package:memento_flutter_client/components/userList.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Controller/amigo_provider.dart';

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
    Amigo_provider amigo_provider =
        Provider.of<Amigo_provider>(context, listen: true);
    SolicitudAmistad_provider solicitudAmistad_provider =
        Provider.of<SolicitudAmistad_provider>(context, listen: true);
    UsuarioList_provider usuarioList_provider =
        Provider.of<UsuarioList_provider>(context, listen: true);
    FriendsCarretes_provider friendsCarretes_provider =
        Provider.of<FriendsCarretes_provider>(context);

    Future refresh() async {
      amigo_provider.getMyAmigos();
      solicitudAmistad_provider.getMySolicitudesAmistad();
      setState(() {});
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
                  Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return ChangeNotifierProvider.value(
                                value: amigo_provider,
                                child: ChangeNotifierProvider.value(
                                    value: solicitudAmistad_provider,
                                    child: ChangeNotifierProvider.value(
                                        value: usuarioList_provider,
                                        child: ChangeNotifierProvider.value(
                                            value: friendsCarretes_provider,
                                            child: userList()))));
                          }),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.addFriends,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  mySolicitudesAmistad(),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
                    child: Text(
                      AppLocalizations.of(context)!.friends_list +
                          " (" +
                          amigo_provider.amigos.length.toString() +
                          ")",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  myAmigos(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
