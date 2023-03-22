
import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Config/Properties.dart' as properties;
import 'Config/Properties.dart';
import 'Model/carrete.dart';



class CarreteCard extends StatelessWidget {
  final Carrete carrete;


  const CarreteCard({Key? key, required this.carrete}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              carrete.ano_mes + " " + carrete.num_fotos.toString() + "/9",
            ),
          ),
          SizedBox(
            height: 150.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: carrete.ids_fotos.length,
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
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage("$SERVER_IP/api/foto"+carrete.ids_fotos[index]),
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
  }
}