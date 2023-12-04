import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:taxverse_admin/utils/const.dart';
import 'package:taxverse_admin/utils/create_path_for_ecryptedata.dart';
import 'package:taxverse_admin/view/widgets/decrypt_data.dart';
import 'package:taxverse_admin/view/widgets/encrypt_data.dart';

class APIs {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  static String documentId = '';

  static Stream<QuerySnapshot<Map<String, dynamic>>> clientdataCollection = FirebaseFirestore.instance.collection('GstClientInfo').orderBy('time',descending: false).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserData(String userID) {
    return FirebaseFirestore.instance.collection('ClientDetails').where('Email', isEqualTo: userID).snapshots();
  }

  static Future getDocumetID() async {
    await firestore.collection('admins').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        documentId = doc.id;
      }
    });
  }

  static Future updateActiveStatus(bool isOnline) async {
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getGstClientInformation(String userEmail, int count) {
    return firestore
        .collection('GstClientInfo')
        .where(
          'Email',
          isEqualTo: userEmail,
        )
        .where(
          'Application_count',
          isEqualTo: count,
        )
        .limit(1)
        .snapshots();
  }

  static Future<ListResult> getFileFromFirebaseStorage(String email, String count) {
    final storage = FirebaseStorage.instance;

    final ref = storage.ref();

    final result = ref.child('UserGstDocuments/$email/GstApplication$count');

    return result.listAll();
  }

  static downloadEncryptedPdfFile(String mail, int count, String fileName, HashMap<String, File> documentFiles) async {
    final storage = FirebaseStorage.instance;
    final storageReference = storage
        .ref('UserGstDocuments/')
        .child(
          '$mail/',
        )
        .child('GstApplication$count/')
        .child(fileName);

    // Download the encrypted data from Firebase Storage

    final folderPath = await createPathForEcrypted(count, mail);

    var downloadTask = storageReference.writeToFile(File('$folderPath/$fileName'));

    // Wait for download to complete

    final snapshot = await downloadTask.whenComplete(() => null);

    if (snapshot.state == TaskState.success) {
      // Read the downloaded encrypted file

      final downloadedFile = File('$folderPath/$fileName');

      final encryptedData = await downloadedFile.readAsBytes();

      final decryptedBytes = decryptByte(encryptedData);

      // convet decrypted bytes to file

      final file = await createPathForDecrypted(decryptedBytes, mail, count, fileName);

      log(file.path);

      documentFiles[fileName.replaceAll("'s", '').trim()] = file;
    }
  }

  static Future<QuerySnapshot<Object?>> accessGstDatabase(String userEmail, int count) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('GstClientInfo')
        .where(
          'Email',
          // isEqualTo: EncryptData().encryptedData(userEmail, generateKey()),
          isEqualTo: userEmail,
        )
        .where('Application_count', isEqualTo: count)
        .get();

    return querySnapshot;
  }
}
