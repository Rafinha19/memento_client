import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/Model/solicitud_amistad.dart';
import 'package:memento_flutter_client/components/carreteDetail.dart';
import 'package:memento_flutter_client/components/displayDialog.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../Config/Properties.dart';
import '../Controller/amigo_provider.dart';
import '../Controller/friendsCarretes_provider.dart';
import '../Controller/solicitudAmistad_provider.dart';
import '../Controller/usuarioList_provider.dart';
import '../Model/usuario.dart';
import '../Model/currentUsuarioData.dart';
import '../repository/AmigoRepository.dart';

class solicitudAmistadCard extends StatefulWidget {
  final Solicitud_amistad solicitud_amistad;
  solicitudAmistadCard({Key? key,required this.solicitud_amistad}) : super(key: key);


  @override
  State<solicitudAmistadCard> createState() => _solicitudAmistadCardState();
}

class _solicitudAmistadCardState extends State<solicitudAmistadCard> {
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
        child: FutureBuilder<String>(
          future: futureToken,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String token = snapshot.data!;
              return SizedBox(
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
                                      widget.solicitud_amistad.url_foto_perfil_actor),
                                ),
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(widget.solicitud_amistad.username_actor,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                        textAlign: TextAlign.center))
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.check_circle_outline,
                                    size: 35,
                                    color: Colors.orange,
                                  ), onPressed: () async {
                                  int res = await AmigoRepository().aceptarSolicitud(widget.solicitud_amistad.id_solicitud_amistad);
                                  if (res == 0){
                                    displayDialog(context, "Solicitud aceptada", "Se ha aceptado la solicitud de amistad del usuario" + widget.solicitud_amistad.username_actor );
                                    //Mandamos a los provider recargarse
                                    amigo_provider.getMyAmigos();
                                    solicitudAmistad_provider.getMySolicitudesAmistad();
                                    usuarioList_provider.getUsuariosNoAmigos();
                                    friendsCarretes_provider.getMyFriendsCarretes();
                                  }else if( res == 1){
                                    displayDialog(context, "Error inesperado", "Ha ocurrido un error inesperado" );
                                  }
                                },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    size: 35,
                                    color: Colors.orange,
                                  ), onPressed: () async {
                                  int res = await AmigoRepository().denegarSolicitud(widget.solicitud_amistad.id_solicitud_amistad);
                                  if (res == 0){
                                    displayDialog(context, "Solicitud denegada", "Se ha denegado la solicitud de amistad del usuario " + widget.solicitud_amistad.username_actor );
                                    //Aqui solo recargo el provider de solicitudes, pues la lista de amigos no varía
                                    solicitudAmistad_provider.getMySolicitudesAmistad();
                                  }else if( res == 1){
                                    displayDialog(context, "Error inesperado", "Ha ocurrido un error inesperado" );
                                  }
                                },
                                )
                              ],
                            )

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
