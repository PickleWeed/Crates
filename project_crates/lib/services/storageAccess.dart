import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class StorageAccess {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file) async {
    StorageReference storageReference =
        storage.ref().child('Listing/${Path.basename(file.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    print('File uploaded');
    String url = await storageReference.getDownloadURL();
    return url;
  }
}
