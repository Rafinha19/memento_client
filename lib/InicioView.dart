import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/components/carreteCard.dart';
import 'package:memento_flutter_client/components/myLastCarrete.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'Model/carrete.dart';
import 'package:memento_flutter_client/TabPage.dart';

import 'Controller/carrete_provider.dart';

class InicioView extends StatefulWidget {
  @override
  _InicioViewState createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Carrete_provider carrete_provider =
        Provider.of<Carrete_provider>(context, listen: true);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
                  myLastCarrete()
            ],
          ),
        ),
      ),
    ));
  }
}
