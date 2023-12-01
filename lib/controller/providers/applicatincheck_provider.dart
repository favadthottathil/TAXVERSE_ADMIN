import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AppliacationCheckProvider extends ChangeNotifier {
  List pdfs = [];

  bool isCheckInformation = false;
  bool isCheckDocuments = false;
  bool isFinalCheck = false;

  bool verificatinStatus = false;

  bool fileUploaded = false;

  bool fileUploading = false;

  bool registrationCompletedLocal = false;

  List pdfsNames = [
    'AADHAARCARD',
    'BUILDING TAX RECEIPT',
    'Electricity bill',
    'PANCARD',
    'RENT AGREEMENT',
  ];

  setFileUploadingTrue() {
    fileUploading = true;
    notifyListeners();
  }

  setRegistrationCompletedLocalTrue() {
    registrationCompletedLocal = true;
    notifyListeners();
  }

  setRegistrationCompletedLocalFalse() {
    registrationCompletedLocal = false;
    notifyListeners();
  }

  List<bool>? checkboxValues;

  verificationStatusToTrue() {
    verificatinStatus = true;
    notifyListeners();
  }

  notifyVerified(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ClientDetails')
        .where(
          'Email',
          isEqualTo: email,
        )
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update({
        'Isverified': 'verified',
        // 'showprogress': true,
      });
    }

    QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
        .collection('ClientGstInfo')
        .where(
          'Email',
          isEqualTo: email,
        )
        .get();
    if (querySnapshot1.docs.isNotEmpty) {
      await querySnapshot1.docs.first.reference.update(
        {
          // 'Isverified': 'verified',
          'application_status': 'true',
          'showprogress': true,
        },
      );
    }
  }

  notifyNotVerified(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ClientDetails')
        .where(
          'Email',
          isEqualTo: email,
        )
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update({
        'Isverified': 'notverified',
      });
    }

    QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
        .collection('ClientGstInfo')
        .where(
          'Email',
          isEqualTo: email,
        )
        .get();
    if (querySnapshot1.docs.isNotEmpty) {
      await querySnapshot1.docs.first.reference.update({
        'application_status': 'false',
      });
    }

    // QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
    //     .collection('ClientDetails')
    //     .where(
    //       'Email',
    //       isEqualTo: email,
    //     )
    //     .get();
    // if (querySnapshot1.docs.isNotEmpty) {
    //   await querySnapshot.docs.first.reference.delete();
    // }
  }

  gstNumberUpload(String email, gstNumber) async {
    QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
        .collection('ClientGstInfo')
        .where(
          'Email',
          isEqualTo: email,
        )
        .get();
    if (querySnapshot1.docs.isNotEmpty) {
      await querySnapshot1.docs.first.reference.update({
        'gst_number': gstNumber,
        'showprogress': false,
        'isRegistrationCompleted': true,
      });
    }
  }

  Future<void> pickFile(String email, String gstNumberController) async {
    FilePickerResult? result;

    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf'
      ],
    );

    fileUploading = true;
    notifyListeners();

    if (result != null) {
      // final documentUploadData = documentUploadDataMap[fieldName];
      // if (documentUploadData != null) {
      //   documentUploadData.showLoading = true;
      //   notifyListeners();
      // }

      File file = File(result.files.single.path!);
      final downloadLink = await uploadPdf(file);

      QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
          .collection('ClientGstInfo')
          .where(
            'Email',
            isEqualTo: email,
          )
          .get();
      if (querySnapshot1.docs.isNotEmpty) {
        await querySnapshot1.docs.first.reference.update({
          'gstcertificate': downloadLink,
        });
      }

      fileUploading = false;
      notifyListeners();

      fileUploaded = true;
      notifyListeners();

      // gstClientInformaion.doc(ClientInformation.gstId).update({
      //   fieldName: downloadLink,
      // });

      // if (documentUploadData != null) {
      //   documentUploadData.showLoading = false;
      //   documentUploadData.isImageUploaded = true;
      //   notifyListeners();
      // }
    } else {
      log('No file Selected');
    }
  }

  Future<String> uploadPdf(File file) async {
    final reference = FirebaseStorage.instance.ref().child("gstcerti");
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }
}
