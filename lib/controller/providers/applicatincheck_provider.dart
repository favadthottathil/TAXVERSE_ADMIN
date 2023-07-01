import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppliacationCheckProvider extends ChangeNotifier {
  List pdfs = [];

  bool verificatinStatus = false;

  List pdfsNames = [
    'AadhaarCard',
    'BUILDING TAX RECEIPT',
    'Electricity bill',
    'PANCARD',
    'RENT AGREEMENT',
  ];

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
      });
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
        .collection('ClientDetails')
        .where(
          'Email',
          isEqualTo: email,
        )
        .get();
    if (querySnapshot1.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.delete();
    }
  }
}
