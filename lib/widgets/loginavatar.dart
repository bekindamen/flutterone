import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Avatar extends StatefulWidget {
  const Avatar({super.key});

  @override
  State<Avatar> createState() => AvatarState();
}

class AvatarState extends State<Avatar> {
  static File? pickedImage;
  bool inProcess = false;
  PickedFile? pickedImageFile;
  CroppedFile? cropimg;

  void crop() async {}

  static bool imagepicked = false;

  void _pickfile() async {
    pickedImageFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    pickedImageFile != null
        ? setState(() {
            inProcess = true;
          })
        : null;
    cropimg = await ImageCropper.platform.cropImage(
        sourcePath: pickedImageFile!.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 700,
        maxWidth: 500,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
              toolbarColor: Colors.grey,
              toolbarTitle: 'Crop image to your preference',
              statusBarColor: Colors.transparent,
              backgroundColor: Colors.black,
              activeControlsWidgetColor: Colors.black45),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ]);
    if (cropimg != null) {
      setState(() {
        inProcess = false;
        pickedImage = File(cropimg!.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a valid image or try again.')));
    }
    pickedImage != null ? imagepicked = true : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (inProcess)
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black54,
            child: Container(
              alignment: Alignment.center,
              color: Colors.black54,
              height: 40,
              width: 40,
              child: const CircularProgressIndicator(),
            ),
          ),
        CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage:
              pickedImage != null ? FileImage(File(pickedImage!.path)) : null,
          radius: 40,
        ),
        TextButton.icon(
          label: Text('Add the image'),
          icon: Icon(Icons.image_rounded),
          onPressed: _pickfile,
        ),
      ],
    );
  }
}
