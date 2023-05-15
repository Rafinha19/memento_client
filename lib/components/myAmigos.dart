import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Controller/amigo_provider.dart';
import 'package:memento_flutter_client/components/userCard.dart';
import 'package:provider/provider.dart';

class myAmigos extends StatefulWidget {
  myAmigos({Key? key}) : super(key: key);

  @override
  State<myAmigos> createState() => _myAmigosState();
}

class _myAmigosState extends State<myAmigos> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Amigo_provider amigo_provider = Provider.of<Amigo_provider>(context, listen: true);

    return
      amigo_provider.isLoading?
      //true
      const CircularProgressIndicator()
          :
      ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: amigo_provider.amigos.length,
          itemBuilder: (context, index) {
            final amigo = amigo_provider.amigos[index];
            return SizedBox(
              height: 90,
              width: double.infinity,
              child: userCard(usuario: amigo, ismyAmigo: true,),
            );
          }
      )
    ;

  }
}