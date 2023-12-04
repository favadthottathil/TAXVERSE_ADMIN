import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:taxverse_admin/Api/api.dart';
import 'package:taxverse_admin/controller/shared_pref/application_check.dart';
import 'package:taxverse_admin/view/widgets/decrypt_data.dart';

import '../../../constants.dart';
import '../../widgets/encrypt_data.dart';

class AppliacationCheckProvider extends ChangeNotifier {
  List pdfs = [];

  bool? isCheckInformation;
  bool? isCheckDocuments;
  bool? isFinalCheck;

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

  // Shared Preference of Application Check

  setIsCheckInformation(String email, int count, bool value) {
    ApplicatinCheckShardpref().isCheckInformation(value, email, count);
  }

 Future<void> getIsCheckInformation(String email, int count) async {
    isCheckInformation = await ApplicatinCheckShardpref().getIsCheckInformation(email, count);
    notifyListeners();
  }

  setIsCheckDocuments(String email, int count, bool value) {
    ApplicatinCheckShardpref().isCheckDocuments(value, email, count);
  }

 Future<void> getIsCheckDocuments(String email, int count) async {
    isCheckDocuments = await ApplicatinCheckShardpref().getisCheckDocuments(email, count);
    notifyListeners();
  }

  setIsFinalCheck(String email, int count, bool value) {
    ApplicatinCheckShardpref().isFinalCheck(value, email, count);
  }

 Future<void> getIsFinalCheck(String email, int count) async {
    isFinalCheck = await ApplicatinCheckShardpref().getIsFinalCheck(email, count);
    notifyListeners();
  }

  setFileUploadingTrue() {
    fileUploading = true;
    notifyListeners();
  }

  set setFileUploaded(bool value) {
    fileUploaded = value;
    notifyListeners();
  }

  set setFileUploading(bool value) {
    fileUploading = value;
    notifyListeners();
  }

  // setRegistrationCompletedLocalTrue() {
  //   registrationCompletedLocal = true;
  //   notifyListeners();
  // }

  // setRegistrationCompletedLocalFalse() {
  //   registrationCompletedLocal = false;
  //   notifyListeners();
  // }

  List<bool>? checkboxValues;

  // verificationStatusToFalse() {
  //   _verificatinStatus = false;
  //   notifyListeners();
  // }

  // setApplicationVerified(bool value) async {
  //   try {
  //     final QuerySnapshot<Object?> querySnapshot = await APIs.accessGstDatabase(userEmail, count);

  //     if (querySnapshot.docs.isNotEmpty) {
  //       await querySnapshot.docs.first.reference.update({
  //         'application_verified': value,
  //       });

  //       log('profile updated');
  //     }
  //   } catch (e) {
  //     log('error $e');
  //   }
  // }

  isFinalCheckToDatbase(String userEmail, int count) async {
    try {
      final QuerySnapshot<Object?> querySnapshot = await APIs.accessGstDatabase(userEmail, count);

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({
          'verifystatus': 1,
          'acceptbutton': true,
          // 'showprogress':true,
        });

        log('profile updated');
      }
    } catch (e) {
      log('error $e');
    }
  }

  isCheckDocumentsToDatbase(String userEmail, int count) async {
    try {
      final QuerySnapshot<Object?> querySnapshot = await APIs.accessGstDatabase(userEmail, count);

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({
          'verifystatus': 1,
        });

        log('profile updated');
      }
    } catch (e) {
      log('error $e');
    }
  }

  isCheckInformationToDatbase(String userEmail, int count) async {
    try {
      final QuerySnapshot<Object?> querySnapshot = await APIs.accessGstDatabase(userEmail, count);

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({
          'verifystatus': 0,
        });

        log('profile updated');
      }
    } catch (e) {
      log('error $e');
    }
  }

  updateStatus(int num, String userEmail, int count) async {
    try {
      final QuerySnapshot<Object?> querySnapshot = await APIs.accessGstDatabase(userEmail, count);

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({
          'statuspercentage': num,
        });

        log('profile updated');
      }
    } catch (e) {
      log('error $e');
    }
  }

  checkValidate(
    String email,
    String gstNumber,
    GlobalKey<FormState> formkey,
    BuildContext context,
    int count,
  ) {
    if (formkey.currentState!.validate()) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        showCloseIcon: true,
        title: 'Submit Information',
        desc: 'Do You want to Submit GST Information',
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
          gstNumberUpload(email, gstNumber, count);
          Navigator.pop(context);
        },
        buttonsBorderRadius: BorderRadius.circular(20),
      ).show();
    }
  }

  notifyVerified(String email, int count) async {
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
      });
    }

    final QuerySnapshot<Object?> gstSnapshot = await APIs.accessGstDatabase(EncryptData().encryptedData(email, generateKey()), count);

    try {
      if (gstSnapshot.docs.isNotEmpty) {
        await gstSnapshot.docs.first.reference.update(
          {
            'application_status': 'accepted',
            'showprogress': true,
            'application_verified': true,
            'acceptbutton': false,
          },
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  notifyNotVerified(String email, int count) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ClientDetails')
        .where(
          'Email',
          isEqualTo: email,
        )
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.set({
        'Isverified': 'notverified',
      });
    }

    final QuerySnapshot<Object?> gstSnapshot = await APIs.accessGstDatabase(email, count);
    await gstSnapshot.docs.first.reference.update({
      'application_status': 'notAccepted',
    });
  }

  gstNumberUpload(String email, gstNumber, count) async {
    final QuerySnapshot<Object?> gstSnapshot = await APIs.accessGstDatabase(email, count);

    await gstSnapshot.docs.first.reference.update({
      'gst_number': gstNumber,
      'showprogress': false,
      'isRegistrationCompleted': true,
      'acceptbutton': false
    });
  }

  Future<void> pickFile(String email, int count) async {
    FilePickerResult? result;

    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf'
      ],
    );

    setFileUploading = true;

    if (result != null) {
      // final documentUploadData = documentUploadDataMap[fieldName];
      // if (documentUploadData != null) {
      //   documentUploadData.showLoading = true;
      //   notifyListeners();
      // }

      File file = File(result.files.single.path!);
      final downloadLink = await uploadPdf(file, email, count);

      QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
          .collection('GstClientInfo')
          .where(
            'Email',
            isEqualTo: email,
          )
          .where(
            'Application_count',
            isEqualTo: count,
          )
          .get();
      if (querySnapshot1.docs.isNotEmpty) {
        await querySnapshot1.docs.first.reference.update({
          'gstcertificate': downloadLink,
        });
      }

      setFileUploading = false;

      setFileUploaded = true;

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

  Future<String> uploadPdf(File file, String userMail, int count) async {
    final reference = FirebaseStorage.instance.ref('UserGstDocuments').child(userMail).child('GstApplication$count').child('gstCertificate');
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }
}
