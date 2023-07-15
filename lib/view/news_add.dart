import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/controller/providers/addnews_provider.dart';

import 'widgets/AddNewsWidgets/addnews_widgets.dart';

class NewsAdd extends StatefulWidget {
  const NewsAdd({super.key});

  @override
  State<NewsAdd> createState() => _NewsAddState();
}

class _NewsAddState extends State<NewsAdd> {
  final CollectionReference newsCollection = FirebaseFirestore.instance.collection('news');

  final autherName = TextEditingController();

  final heading = TextEditingController();

  final description = TextEditingController();

  addNewsToDatabase(String autherName, String newsHeading, String description, String imageurl) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await newsCollection.add({
        'auther': autherName,
        'newsHeading': newsHeading,
        'description': description,
        'image': imageurl,
        'time': time,
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
        body: Consumer<AddNewsProvider>(builder: (
          context,
          provider,
          child,
        ) {
          return Padding(
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
                  autherNameTextfield(autherName),
                  const SizedBox(height: 10),
                  headLineTextfield(heading),
                  const SizedBox(height: 10),
                  Text(
                    'upload news picture',
                    style: AppStyle.poppinsRegular15,
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {
                      provider.addNewsPicture();
                    },
                    icon: const Icon(Icons.upload),
                    label: const Text('upload'),
                  ),
                  const SizedBox(height: 10),
                  provider.selectedImage != null
                      ? Image.file(
                          File(provider.selectedImage!.path),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 20),
                  descriptionTextfield(description),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.scale,
                        showCloseIcon: true,
                        desc: 'Do You want to Add news??',
                        btnOkColor: Colors.green,
                        btnOkText: 'Yes',
                        btnCancelText: 'Cancel',
                        btnCancelOnPress: () {},
                        btnCancelColor: Colors.red,
                        buttonsTextStyle: AppStyle.poppinsBold16,
                        dismissOnBackKeyPress: true,
                        titleTextStyle: AppStyle.poppinsBoldGreen16,
                        descTextStyle: AppStyle.poppinsBold16,
                        transitionAnimationDuration: const Duration(milliseconds: 500),
                        btnOkOnPress: () {
                          addNewsToDatabase(
                            autherName.text.trim(),
                            heading.text.trim(),
                            description.text.trim(),
                            provider.imageurl,
                          );

                          provider.selectedImage = null;

                          Navigator.pop(context);
                        },
                        buttonsBorderRadius: BorderRadius.circular(20),
                      ).show();
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
          );
        }),
      ),
    );
  }
}
