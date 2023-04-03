import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:provider/provider.dart';


import '../Config/Properties.dart';
import '../Model/carrete_provider.dart';
import 'carreteCard.dart';

class myLastCarrete extends StatefulWidget {
  myLastCarrete({Key? key}) : super(key: key);

  @override
  State<myLastCarrete> createState() => _myLastCarreteState();
}

class _myLastCarreteState extends State<myLastCarrete> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Carrete_provider carrete_provider = Provider.of<Carrete_provider>(context, listen: true);

    return
      carrete_provider.isLoading?
      //true
      const CircularProgressIndicator()
          :
      SizedBox(
        height: 200,
        width: double.infinity,
        child: carreteCard(
            carrete: carrete_provider.carretes[0],
            ismyLastcarrete: true),
      )
    ;

  }
}
