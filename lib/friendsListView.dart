import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Controller/carrete_provider.dart';
import 'package:memento_flutter_client/Model/usuario.dart';
import 'package:memento_flutter_client/Controller/usuario_provider.dart';
import 'package:memento_flutter_client/components/myCarretes.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/components/carreteCard.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'Model/carrete.dart';
import 'package:memento_flutter_client/Config/Properties.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/displayDialog.dart';
import 'components/loading_overlay.dart';
import 'loginView.dart';

class friendsListView extends StatefulWidget {
  @override
  _friendsListViewState createState() => _friendsListViewState();
}

class _friendsListViewState extends State<friendsListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Memento',
              style: TextStyle(fontSize: 26),
            ),
            backgroundColor: AppbackgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text("Friends List")
                ],
              ),
            ),
          ),
        ));
  }
}
