import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Controller/friendsCarretes_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'carreteCard.dart';

class myFriendsCarretes extends StatefulWidget {
  myFriendsCarretes({Key? key}) : super(key: key);

  @override
  State<myFriendsCarretes> createState() => _myFriendsCarretesState();
}

class _myFriendsCarretesState extends State<myFriendsCarretes> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FriendsCarretes_provider friendsCarretes_provider = Provider.of<FriendsCarretes_provider>(context, listen: true);
    return
      friendsCarretes_provider.isLoading?
      //true
      const CircularProgressIndicator()
          :
      friendsCarretes_provider.carretesAmigos.length==0?
      Text(AppLocalizations.of(context)!.youHaventAddedUsers)
          :    
      ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: friendsCarretes_provider.carretesAmigos.length,
          itemBuilder: (context, index) {
            final carrete = friendsCarretes_provider.carretesAmigos[index];
            return SizedBox(
              height: 200,
              width: double.infinity,
              child: carreteCard(carrete: carrete, ismyLastcarrete: false, isInicioCarrete: true, isMycarrete: false,),
            );
          }
      )
    ;

  }
}
