import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/carreteCard.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'dart:convert';
import 'Model/carrete.dart';
import 'package:memento_flutter_client/TabPage.dart';

class InicioView extends StatefulWidget {
  @override
  _InicioViewState createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> {
  late Future<Carrete> futureMyLastCarrete;

  @override
  void initState() {
    super.initState();
    futureMyLastCarrete = CarreteRepository().getMyLastCarrete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: FutureBuilder<Carrete>(
                    future: futureMyLastCarrete,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        //return CarreteCard(carrete: snapshot.data!);
                        return carreteCard(
                            carrete: snapshot.data!, ismyLastcarrete: true);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    }),
              ),

            ],
          ),
        ),
      ),
    ));
  }
}
