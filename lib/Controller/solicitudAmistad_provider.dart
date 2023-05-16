import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:memento_flutter_client/Model/amigo.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/Model/solicitud_amistad.dart';
import 'package:memento_flutter_client/Model/usuario.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/repository/AmigoRepository.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:memento_flutter_client/repository/UsersRepository.dart';
import 'package:provider/provider.dart';

class SolicitudAmistad_provider extends ChangeNotifier {
  late List<Solicitud_amistad> solicitudes_amistad;
  //Por defecto lo dejamos como si estuviera cargando
  bool isLoading = true;
  bool hasErrors = false;

  SolicitudAmistad_provider(){
    this.getMySolicitudesAmistad();
  }

  Future<void> getMySolicitudesAmistad() async {
    try{
      this.isLoading =true;
      this.solicitudes_amistad = await AmigoRepository().getMySolicitudesAmistad();
      this.isLoading = false;
      notifyListeners();
    }catch(e){
      this.hasErrors=true;
      notifyListeners();
    }
  }


}