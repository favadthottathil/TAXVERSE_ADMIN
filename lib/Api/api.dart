import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:taxverse_admin/utils/const.dart';

class APIs {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  static String documentId = '';

  static Future getDocumetID() async  {
   await firestore.collection('admins').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        documentId = doc.id;
        log(' 666666=== $documentId');
        
      }
    });
  }

  static Future<String?> updateActiveStatus(bool isOnline) async {
    log('hdfhdhahhaja   $documentId');

    try {
      await firestore.collection('admins').doc(documentId).update({
        'is_online': isOnline,
      });
      log('updated as $isOnline');
    } catch (e) {
      log('errorrrr === $e');
    }
  }

  static Future<void> deleteChat(String docId, var message) async {
    await firestore.collection('chats').doc(docId).delete();

    if (!checkImage(message: message)) {
      await firebaseStorage.refFromURL(docId).delete();
    }
  }
}
