import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Api {
  // final FirebaseStorage storage = ;

  static Future<bool> UploadImage(File file) async {
    try {
      final ext = file.path.split('.').last;
      final ref = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.$ext');

      await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
      return true;
    } catch (e) {
      print('Erro $e');
      return false;
    }
  }
}
