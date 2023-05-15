import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/components/carreteDetail.dart';
import 'package:memento_flutter_client/components/displayDialog.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Config/Properties.dart';
import '../Model/amigo.dart';
import '../Model/usuario.dart';
import '../repository/AmigoRepository.dart';

class userCard extends StatefulWidget {
  final Amigo usuario;
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
                                Icons.highlight_remove,
                                size: 35,
                                color: Colors.orange,
                              ), onPressed: () {
                              print("hola");
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
                                  displayDialog(context, "Solicitud creada", "Se ha creado la solicitud de amistad con el usuario " + widget.usuario.nombre_usuario );
                                }else if( res == 1){
                                  displayDialog(context, "Solicitud pendiente", "Ya hay una solicitud pendiente con el usuario " + widget.usuario.nombre_usuario );
                                }else if( res == 2){
                                  displayDialog(context, "Solicitud pendiente", "Ya tienes una solicitud pendiente del usuario " + widget.usuario.nombre_usuario );
                                }
                            },
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
