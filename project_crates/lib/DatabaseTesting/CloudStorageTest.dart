import 'dart:io';
import 'package:flutter_application_1/services/storageAccess.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CloudStorageTest extends StatefulWidget {
  @override
  _CloudStorageTestState createState() => _CloudStorageTestState();
}

class _CloudStorageTestState extends State<CloudStorageTest> {
  final imagePicker = ImagePicker();
  StorageAccess storageAccess = new StorageAccess();
  File _image;
  String _uploadedFileURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore File Upload'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Selected Image'),
            _image != null
                ? Image.file(
                    _image,
                    height: 150,
                  )
                : Container(height: 150),
            _image == null
                ? RaisedButton(
                    child: Text('Choose File'),
                    onPressed: chooseFile,
                    color: Colors.cyan,
                  )
                : Container(),
            _image != null
                ? RaisedButton(
                    child: Text('Upload File'),
                    onPressed: () async {
                      String url = await storageAccess.uploadFile(_image);
                      setState(() {
                        _uploadedFileURL = url;
                      });
                    },
                    color: Colors.cyan,
                  )
                : Container(),
            _image != null
                ? RaisedButton(
                    child: Text('Clear Selection'),
                    onPressed: clearSelection,
                  )
                : Container(),
            Text('Uploaded Image'),
            _uploadedFileURL != null
                ? Image.network(
                    _uploadedFileURL,
                    height: 150,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future chooseFile() async {
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      print('No image selected.');
      return;
    }
    File file = File(pickedFile.path);
    setState(() {
      _image = file;
    });
  }

  void clearSelection() {
    setState(() {
      _image = null;
      _uploadedFileURL = null;
    });
  }
}
