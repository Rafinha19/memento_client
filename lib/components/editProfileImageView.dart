import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memento_flutter_client/Config/Properties.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memento_flutter_client/components/select_photo_options_screen.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:memento_flutter_client/components/loading_overlay.dart';

import '../Controller/currentUsuario_provider.dart';
import 'displayDialog.dart';

class editProfileImageView extends StatefulWidget {
  final String username;
  editProfileImageView({Key? key, required this.username}) : super(key: key);

  @override
  State<editProfileImageView> createState() => _editProfileImageViewState();
}

class _editProfileImageViewState extends State<editProfileImageView> {
  @override
  void initState() {
    super.initState();
  }

  File? _image;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: AppLocalizations.of(context)!.editPhoto,
          toolbarColor: AppbackgroundColor,
          statusBarColor: AppbackgroundColor,
          toolbarWidgetColor: Colors.white,
          backgroundColor: AppbackgroundColor,
        ),
        IOSUiSettings(title: AppLocalizations.of(context)!.editPhoto)
      ],
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
    );
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
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
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 12, right: 12, bottom: 30, top: 100),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                    widget.username,
                    textAlign: TextAlign.left,
                    textScaleFactor: 3.0,
                    overflow: TextOverflow.ellipsis,
                  )),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 30.0),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _showSelectPhotoOptions(context);
                      },
                      child: Center(
                        child: Container(
                            height: 300.0,
                            width: 300,
                            decoration: BoxDecoration(
                                color: Colors.grey[850],
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade800)),
                            child: Center(
                                child: _image == null
                                    ? CircleAvatar(
                                  radius: 300, // Image radius
                                  backgroundImage: NetworkImage(
                                      "$SERVER_IP/api/users/" +
                                          widget.username +
                                          "/image"),
                                )
                                    : CircleAvatar(
                                        backgroundImage: FileImage(_image!),
                                        radius: 300.0,
                                      ))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:30,bottom: 30.0),
                    child: Text(
                      "Editar foto de perfil",
                      textAlign: TextAlign.left,
                      textScaleFactor: 2.0,
                      overflow: TextOverflow.ellipsis,),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {
                            _showSelectPhotoOptions(context);
                          },
                          child: Text(
                            "Selecciona una nueva foto",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: _image != null ?
                            Colors.orange : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () async {
                            if(_image != null){
                              LoadingOverlay.of(context).show();
                              var res =  await AccountRepository().updateProfileImage(_image!);
                              LoadingOverlay.of(context).hide();
                              if(res== 0){
                                imageCache.clear();
                                imageCache.clearLiveImages();
                                Navigator.pop(context);
                                displayDialog(context, AppLocalizations.of(context)!.changesSaved, "foto de perfil actualizada");
                              }else if(res == 1){
                                displayDialog(context, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.unexpected_error);
                              }else{
                                displayDialog(context, AppLocalizations.of(context)!.connection_error, AppLocalizations.of(context)!.connection_error_description);
                              }

                            }else{
                              displayDialog(context, "Selecciona una foto", "Selecciona una foto nueva");
                            }
                          },
                          child: Text(
                            "Guardar cambios",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
