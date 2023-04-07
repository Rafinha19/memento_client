import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/components/carreteDetail.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';

import '../Config/Properties.dart';

class carreteCard extends StatefulWidget {

  final Carrete carrete;
  final bool ismyLastcarrete;

  carreteCard({Key? key, required this.carrete, required this.ismyLastcarrete}) : super(key: key);

  @override
  State<carreteCard> createState() => _carreteCardState();
}

class _carreteCardState extends State<carreteCard> {
  late Future<String> futureToken;


  @override
  void initState() {
    super.initState();
    futureToken = AccountRepository().getJwtToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: FutureBuilder<String>(
            future: futureToken,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String token = snapshot.data!;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => carreteDetail(carrete: widget.carrete)
                        )
                    );
                  },
                  onDoubleTap: (){
                    print("liked");
                  },
                  child: Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.ismyLastcarrete ? "Carrete actual " + widget.carrete.num_fotos.toString() + "/9" : CarreteRepository().toUpperCaseFirstLetter(DateFormat('MMMM',Localizations.localeOf(context).languageCode).format(DateTime(widget.carrete.ano,widget.carrete.mes))) + " " + widget.carrete.ano.toString() ,
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              )
                              ,
                              Text(
                                widget.ismyLastcarrete ?  CarreteRepository().toUpperCaseFirstLetter(DateFormat('MMMM',Localizations.localeOf(context).languageCode).format(DateTime(widget.carrete.ano,widget.carrete.mes))) + " " + widget.carrete.ano.toString() : widget.carrete.num_fotos.toString() + "/9",
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 150.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.carrete.ids_fotos.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (index > 8) {
                                // Only display up to 9 images
                                return SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        "$SERVER_IP/api/fotos/"+widget.carrete.ids_fotos[index].toString(),
                                        headers: {
                                          'Authorization': 'Bearer $token', //'beare
                                        }
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      );
  }
}