import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxverse_admin/controller/providers/chatRoom_provider.dart';

getGstClientDetails() async {
  try {
    final CollectionReference gstClientInfoCollection = firestore.collection('GstClientInfo');

    QuerySnapshot querySnapshot = await gstClientInfoCollection.get();

    print(querySnapshot.docs);
  } catch (e) {
    log('favad ==== $e');
  }
}
