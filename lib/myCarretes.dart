import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/myCarretesEspecific.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';


import 'Config/Properties.dart';
import 'carreteCard.dart';

class myCarretes extends StatefulWidget {
  myCarretes({Key? key}) : super(key: key);

  @override
  State<myCarretes> createState() => _myCarretesState();
}

class _myCarretesState extends State<myCarretes> {
  late Future<List<Carrete>> futureMyCarretes;

  @override
  void initState() {
    super.initState();
    futureMyCarretes = CarreteRepository().getMyCarretes();
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<List<Carrete>>(
          future: futureMyCarretes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //return CarreteCard(carrete: snapshot.data!);
              List<Carrete> carretes = snapshot.data!;
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: carretes.length,
                  itemBuilder: (context, index) {
                    final carrete = carretes[index];
                      return SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: myCarretesEspecific(carrete: carrete),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          }
    );
  }
}
