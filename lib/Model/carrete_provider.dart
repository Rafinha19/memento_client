import 'package:flutter/cupertino.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/Model/usuario.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:memento_flutter_client/repository/UsersRepository.dart';
import 'package:provider/provider.dart';

class Carrete_provider extends ChangeNotifier {
  late List<Carrete> carretes;
  //Por defecto lo dejamos como si estuviera cargando
  bool isLoading = true;

  Carrete_provider(){
    this.getMyCarretes();
  }

  Future<void> getMyCarretes() async {
    this.isLoading =true;
    this.carretes = await CarreteRepository().getMyCarretes();
    this.isLoading = false;
    notifyListeners();
  }


}