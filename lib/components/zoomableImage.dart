import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:provider/provider.dart';


import '../Config/Properties.dart';
import '../Controller/carrete_provider.dart';
import 'carreteCard.dart';

class zoomableImage extends StatefulWidget {
  final String imageUrl;
  final String token;
  zoomableImage({Key? key, required this.imageUrl,required this.token}) : super(key: key);

  @override
  State<zoomableImage> createState() => _zoomableImageState();
}

class _zoomableImageState extends State<zoomableImage> with SingleTickerProviderStateMixin{

  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    super.initState();

    controller = TransformationController();
    animationController = AnimationController(
        vsync: this,
    duration: Duration(microseconds: 200),
    )..addListener(() => controller.value = animation!.value);

  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    void resetAnimation(){
      animation = Matrix4Tween(
        begin: controller.value,
        end: Matrix4.identity(),
      ).animate(CurvedAnimation(parent: animationController, curve: Curves.decelerate));

      animationController.forward(from:0);
    }
    
    String token = widget.token;
    return
      InteractiveViewer(
        transformationController: controller,
        clipBehavior: Clip.none,
        panEnabled: false,
        minScale: 1,
        maxScale: 4,
        onInteractionEnd: (details){
          resetAnimation();
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
            headers: {
              'Authorization': 'Bearer $token', //'beare
            },
          ),
        ),
      );
  

  }
}
