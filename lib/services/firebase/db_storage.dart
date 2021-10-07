import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorage {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  void getImage(String url) {
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('images/fashion.png');
  }
}
