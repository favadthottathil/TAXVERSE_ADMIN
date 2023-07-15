import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewsProvider extends ChangeNotifier {
  XFile? selectedImage;

  String imageurl = '';

  addNewsPicture() async {
    User? user = FirebaseAuth.instance.currentUser;

    log('jdlfka');

    if (user != null) {
      print('favad');
      String uid = user.uid;

      ImagePicker imagePicker = ImagePicker();

      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

      if (file == null) return;

      selectedImage = file;
      notifyListeners();

      Reference reference = FirebaseStorage.instance.ref();
      Reference referenceDirImage = reference.child('news');
      Reference referenceImageToUpload = referenceDirImage.child(uid);

      try {
        await referenceImageToUpload.putFile(File(file.path));
        imageurl = await referenceImageToUpload.getDownloadURL();
      } catch (e) {
        log('$e');
      }
    }
    log('message');
  }
}
