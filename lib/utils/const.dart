import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

bool checkImage({required var message}) {
  if ((message as Map<String, dynamic>)['image'] == '') {
    return true;
  } else {
    return false;
  }
}

var sizedBoxHeight10 = const SizedBox(height: 10);

var sizedBoxHeight20 = const SizedBox(height: 20);

var sizedBoxHeight40 = const SizedBox(height: 40);

List<QueryDocumentSnapshot<Map<String, dynamic>>> appoinmentGlobal = [];
