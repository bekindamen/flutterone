import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Avatar extends StatefulWidget {
  BoxShape boxShape;
  Avatar({super.key, required this.boxShape});

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
    double yRatio;
    if (widget.boxShape == BoxShape.circle)
      yRatio = 1;
    else
      yRatio = 1.6;

    cropimg = await ImageCropper.platform.cropImage(
        sourcePath: pickedImageFile!.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: yRatio),
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
    setState(() {
      pickedImage != null ? imagepicked = true : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.boxShape != BoxShape.rectangle)
          if (inProcess)
            Container(
              height: widget.boxShape == BoxShape.circle
                  ? MediaQuery.of(context).size.height
                  : MediaQuery.of(context).size.height * 0.3,
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
        widget.boxShape == BoxShape.rectangle
            ? Container(
                height: 160,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: pickedImage != null
                        ? Image(image: FileImage(File(pickedImage!.path))).image
                        : Image.asset('res/no-profile-picture-icon.png').image,
                  ),
                ),
              )
            : CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 35,
                backgroundImage: pickedImage != null
                    ? Image(image: FileImage(File(pickedImage!.path))).image
                    : Image.asset('res/no-profile-picture-icon.png').image,
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
