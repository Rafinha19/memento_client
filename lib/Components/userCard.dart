import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter_client/components/displayDialog.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:provider/provider.dart';

import '../Config/Properties.dart';
import '../Controller/amigo_provider.dart';
import '../Controller/friendsCarretes_provider.dart';
import '../Controller/solicitudAmistad_provider.dart';
import '../Controller/usuarioList_provider.dart';
import '../Model/usuario.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../repository/AmigoRepository.dart';

class userCard extends StatefulWidget {
  final Usuario usuario;
  final bool ismyAmigo;
  userCard({Key? key,required this.usuario, required this.ismyAmigo}) : super(key: key);


  @override
  State<userCard> createState() => _userCardState();
}

class _userCardState extends State<userCard> {
  late Future<String> futureToken;

  @override
  void initState() {
    super.initState();
    futureToken = AccountRepository().getJwtToken();
  }

  @override
  Widget build(BuildContext context) {
    Amigo_provider amigo_provider = Provider.of<Amigo_provider>(context, listen: true);
    SolicitudAmistad_provider solicitudAmistad_provider = Provider.of<SolicitudAmistad_provider>(context, listen: true);
    UsuarioList_provider usuarioList_provider= Provider.of<UsuarioList_provider>(context, listen: true);
    FriendsCarretes_provider friendsCarretes_provider = Provider.of<FriendsCarretes_provider>(context);

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: 90,
          child: Card(
            color: Colors.grey[850],
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30, // Image radius
                            backgroundImage: NetworkImage(
                                "$SERVER_IP/api/users/" + widget.usuario.nombre_usuario + "/image"),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(widget.usuario.nombre_usuario,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  textAlign: TextAlign.center))
                        ],
                      ),
                      widget.ismyAmigo?
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 35,
                          color: Colors.orange,
                        ), onPressed: () async {
                        int res = await AmigoRepository().borrarAmigo(widget.usuario.id_usuario);
                        if (res == 0){
                          displayDialog(context, AppLocalizations.of(context)!.friendshipDeleted, AppLocalizations.of(context)!.friendshipDeletedDESC + widget.usuario.nombre_usuario );
                          amigo_provider.getMyAmigos();
                          usuarioList_provider.getUsuariosNoAmigos();
                          friendsCarretes_provider.getMyFriendsCarretes();
                        }else if( res == 1){
                          displayDialog(context, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.unexpected_error );
                        }
                      },
                      )
                          :
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          size: 35,
                          color: Colors.orange,
                        ), onPressed: () async {
                        int res = await AmigoRepository().crearSolicitudAmistad(widget.usuario.id_usuario);
                        if (res == 0){
                          displayDialog(context, AppLocalizations.of(context)!.friendRequestCREATED, AppLocalizations.of(context)!.friendRequestCREATED_DESC + widget.usuario.nombre_usuario );
                          solicitudAmistad_provider.getMySolicitudesAmistad();
                        }else if( res == 1){
                          displayDialog(context, AppLocalizations.of(context)!.friendRequestPENDING, AppLocalizations.of(context)!.pendingFriendRequestWITHUser + widget.usuario.nombre_usuario );
                        }else if( res == 2){
                          displayDialog(context, AppLocalizations.of(context)!.friendRequestPENDING, AppLocalizations.of(context)!.pendingFriendRequestFROMUser + widget.usuario.nombre_usuario );
                        }else {
                          displayDialog(context, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.unexpected_error );
                        }
                      },
                      )

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
