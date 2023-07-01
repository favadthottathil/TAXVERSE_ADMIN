import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxverse_admin/constants.dart';

class NewsAdd extends StatefulWidget {
  const NewsAdd({super.key});

  @override
  State<NewsAdd> createState() => _NewsAddState();
}

class _NewsAddState extends State<NewsAdd> {
  XFile? selectedImage;

  String imageurl = '';

  final CollectionReference newsCollection = FirebaseFirestore.instance.collection('news');

  final autherName = TextEditingController();

  final heading = TextEditingController();

  final description = TextEditingController();

  void createNotification(String title, String message) {
    FirebaseFirestore.instance.collection('notification').add({
      'title': title,
      'message': message,
      'time': FieldValue.serverTimestamp(),
    });
  }

  addNewsToDatabase(
    String autherName,
    String newsHeading,
    String description,
  ) async {
    try {
      final DocumentReference doc = await newsCollection.add({
        'auther': autherName,
        'newsHeading': newsHeading,
        'description': description,
        'image': imageurl,
      });
    } catch (e) {
      log('$e');
    }
  }

  @override
  void dispose() {
    autherName.dispose();
    heading.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add News',
                  style: AppStyle.poppinsBold24,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: autherName,
                  decoration: InputDecoration(
                    hintText: 'Enter Auther Name',
                    hintStyle: AppStyle.poppinsRegular16,
                    labelText: 'Auther Name',
                    labelStyle: AppStyle.poppinsRegular16,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: blackColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: blackColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: heading,
                  decoration: InputDecoration(
                    hintText: 'Enter News Headline',
                    hintStyle: AppStyle.poppinsRegular16,
                    labelText: 'Headline',
                    labelStyle: AppStyle.poppinsRegular16,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: blackColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: blackColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'upload news picture',
                  style: AppStyle.poppinsRegular15,
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () async {
                    User? user = FirebaseAuth.instance.currentUser;

                    log('jdlfka');

                    if (user != null) {
                      print('favad');
                      String uid = user.uid;

                      ImagePicker imagePicker = ImagePicker();

                      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                      if (file == null) return;

                      setState(() {
                        selectedImage = file;
                      });

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
                  },
                  icon: const Icon(Icons.upload),
                  label: const Text('upload'),
                ),
                const SizedBox(height: 10),
                selectedImage != null
                    ? Image.file(
                        File(selectedImage!.path),
                      )
                    : const SizedBox(),
                const SizedBox(height: 20),
                TextFormField(
                  controller: description,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: 'Descrption',
                    labelStyle: AppStyle.poppinsRegular16,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: blackColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: blackColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    addNewsToDatabase(
                      autherName.text.trim(),
                      heading.text.trim(),
                      description.text.trim(),
                    );
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        color: blackColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Add News',
                          style: AppStyle.poppinsBoldWhite20,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
