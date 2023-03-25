import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';

import 'Config/Properties.dart';

class myCarretesEspecific extends StatefulWidget {

  final Carrete carrete;

  myCarretesEspecific({Key? key, required this.carrete}) : super(key: key);

  @override
  State<myCarretesEspecific> createState() => _myCarretesEspecificState();
}

class _myCarretesEspecificState extends State<myCarretesEspecific> {
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
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.carrete.ano_mes,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          Text(
                            widget.carrete.num_fotos.toString() + "/9",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
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
                              width: 150.0,
                              height: 150.0,
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