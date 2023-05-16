import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';

class FriendsCarretes_provider extends ChangeNotifier {
  late List<Carrete> carretesAmigos;
  //Por defecto lo dejamos como si estuviera cargando
  bool isLoading = true;
  bool hasErrors = false;

  FriendsCarretes_provider(){
    this.getMyFriendsCarretes();
  }

  Future<void> getMyFriendsCarretes() async {
    try{
      this.isLoading =true;
      this.carretesAmigos = await CarreteRepository().getMyFriendsCarretes();
      this.isLoading = false;
      notifyListeners();
    }catch(e){
      this.hasErrors=true;
      notifyListeners();
    }
  }



}