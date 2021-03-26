import 'dart:typed_data';

import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

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

  Future<File> fileFromImageUrl(String url) async {
    StorageReference storageRef = await storage.getReferenceFromUrl(url);

    Uint8List image = await storageRef.getData(10 * 1024 * 1024); //10MB limit

    Directory tempDir = await getTemporaryDirectory();

    File imageFile = await new File('${tempDir.path}/image.jpg').create();

    imageFile.writeAsBytesSync(image);

    return imageFile;
  }
}
