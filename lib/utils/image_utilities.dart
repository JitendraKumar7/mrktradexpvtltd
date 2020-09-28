import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class UtilsImage {
  // Crop Image
  static Future<File> _cropImage(filePath) {
    return ImageCropper.cropImage(
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      sourcePath: filePath,
      maxHeight: 512,
      maxWidth: 512,
    );
  }

  static Future<File> getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 1024,
      maxWidth: 1024,
    );
    return _cropImage(pickedFile.path);
  }

  static Future<File> getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 1024,
      maxWidth: 1024,
    );
    return _cropImage(pickedFile.path);
  }
}
/*Container(
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              )



               return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });


              */
