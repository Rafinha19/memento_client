import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Controller/amigo_provider.dart';
import 'package:memento_flutter_client/Controller/solicitudAmistad_provider.dart';
import 'package:memento_flutter_client/components/solicitudAmistadCard.dart';
import 'package:memento_flutter_client/components/userCard.dart';
import 'package:provider/provider.dart';

import '../Model/solicitud_amistad.dart';
import '../repository/AmigoRepository.dart';

class mySolicitudesAmistad extends StatefulWidget {
  mySolicitudesAmistad({Key? key}) : super(key: key);

  @override
  State<mySolicitudesAmistad> createState() => _mySolicitudesAmistadState();
}

class _mySolicitudesAmistadState extends State<mySolicitudesAmistad> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SolicitudAmistad_provider solicitudAmistad_provider = Provider.of<SolicitudAmistad_provider>(context, listen: true);

    return
    Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
          child: Text("Solicitudes list",style: TextStyle(color: Colors.white, fontSize: 20),),
        ),
        solicitudAmistad_provider.isLoading?
    //true
    const CircularProgressIndicator()
            :
        solicitudAmistad_provider.solicitudes_amistad.length==0?
        Text("No hay nuevas solicitudes")
        :
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: solicitudAmistad_provider.solicitudes_amistad.length,
            itemBuilder: (context, index) {
              final solicitud = solicitudAmistad_provider.solicitudes_amistad[index];
              return SizedBox(
                height: 90,
                width: double.infinity,
                child: solicitudAmistadCard(solicitud_amistad: solicitud),
              );
            }
        )
      ],
    );

  }
}