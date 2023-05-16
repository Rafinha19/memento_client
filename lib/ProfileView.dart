import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Controller/amigo_provider.dart';
import 'package:memento_flutter_client/Controller/friendsCarretes_provider.dart';
import 'package:memento_flutter_client/Controller/myCarretes_provider.dart';
import 'package:memento_flutter_client/Controller/solicitudAmistad_provider.dart';
import 'package:memento_flutter_client/Controller/usuarioList_provider.dart';
import 'package:memento_flutter_client/Model/currentUsuarioData.dart';
import 'package:memento_flutter_client/Controller/currentUsuario_provider.dart';
import 'package:memento_flutter_client/components/myCarretes.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/loading_overlay.dart';
import 'friendsView.dart';
import 'loginView.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CurrentUsuario_provider currentUsuario_provider =
        Provider.of<CurrentUsuario_provider>(context);
    MyCarretes_provider carrete_provider =
        Provider.of<MyCarretes_provider>(context);
    Amigo_provider amigo_provider = Provider.of<Amigo_provider>(context);
    SolicitudAmistad_provider solicitudAmistad_provider =
        Provider.of<SolicitudAmistad_provider>(context);
    UsuarioList_provider usuarioList_provider =
        Provider.of<UsuarioList_provider>(context);
    FriendsCarretes_provider friendsCarretes_provider =
        Provider.of<FriendsCarretes_provider>(context);

    Future refresh() async {
      carrete_provider.getMyCarretes();
      setState(() {});
    }

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
      child: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      currentUsuario_provider.isLoading
                          ?
                          //true
                          const CircularProgressIndicator()
                          : CircleAvatar(
                              radius: 40, // Image radius
                              backgroundImage: NetworkImage(
                                  currentUsuario_provider
                                      .usuario.url_foto_perfil),
                            ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: currentUsuario_provider.isLoading
                            ?
                            //true
                            const CircularProgressIndicator()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      currentUsuario_provider
                                          .usuario.nombre_usuario,
                                      textAlign: TextAlign.left),
                                  currentUsuario_provider
                                              .usuario.num_carretes ==
                                          1
                                      ? Text(
                                          currentUsuario_provider
                                                  .usuario.num_carretes
                                                  .toString() +
                                              AppLocalizations.of(context)!
                                                  .reel_singular,
                                          textAlign: TextAlign.left)
                                      : Text(
                                          currentUsuario_provider
                                                  .usuario.num_carretes
                                                  .toString() +
                                              AppLocalizations.of(context)!
                                                  .reel_plural,
                                          textAlign: TextAlign.left)
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
                                    builder: (context) =>
                                        LoadingOverlay(child: LoginView())));
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
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, left: 4, right: 4),
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
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, left: 4, right: 4),
                  child: Container(
                    height: 35,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
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
                                            child: friendsView()))));
                          }),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.friends_list,
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
      ),
    ));
  }
}
