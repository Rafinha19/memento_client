import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:provider/provider.dart';


import '../Config/Properties.dart';
import '../Model/carrete_provider.dart';
import 'carreteCard.dart';

class myCarretes extends StatefulWidget {
  myCarretes({Key? key}) : super(key: key);

  @override
  State<myCarretes> createState() => _myCarretesState();
}

class _myCarretesState extends State<myCarretes> {

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
     ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: carrete_provider.carretes.length,
        itemBuilder: (context, index) {
          final carrete = carrete_provider.carretes[index];
          return SizedBox(
            height: 200,
            width: double.infinity,
            child: carreteCard(carrete: carrete, ismyLastcarrete: index==0? true:false),
          );
        }
        )
    ;

  }
}
