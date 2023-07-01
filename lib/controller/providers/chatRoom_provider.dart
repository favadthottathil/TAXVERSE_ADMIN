import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class ChatRoomProvider extends ChangeNotifier {
  bool isUploading = false;

  String imageUrl = '';

  List<String> imageUrls = [];

  bool showEmoji = false;

   String clientToken = '';

  updateMessageReadStatus(String messageID) {
    firestore.collection('chats').doc(messageID).update({
      'read': 'read',
    });
  }

  emojiState() {
    showEmoji = !showEmoji;

    notifyListeners();
  }

  void sendImage(String imageId, String userid) {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore.collection('chats').add({
      'participants': [
        userid,
        'admin'
      ],
      'text': '',
      'time': time,
      'sender': userid,
      'read': '',
      'image': imageId,
    });

    isUploading = false;
    notifyListeners();

    // imageUrls.remove(imageId);
  }

  void sendMessage(String message, String userid) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    DocumentReference documentRef = await firestore.collection('chats').add({
      'participants': [
        userid,
        'admin'
      ],
      'text': message,
      'time': time,
      'sender': userid,
      'read': '',
      'image': '',
    });
  }

  Future<void> pickFromCamera() async {
    ImagePicker imagePicker = ImagePicker();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

      if (file != null) {
        Uint8List imageFile = await file.readAsBytes();
        try {
          isUploading = true;
          notifyListeners();

          Reference referenceRoot = FirebaseStorage.instance.ref();
          Reference referenceDirImages = referenceRoot.child('chatImages').child(uid);
          UploadTask uploadTask = referenceDirImages.putData(imageFile);
          TaskSnapshot snap = await uploadTask;
          imageUrl = await snap.ref.getDownloadURL();
        } catch (error) {
          print('$error');
        }
      }

      // if (file.isNotEmpty) {}
    }
  }

  Future<void> pickFromGallery() async {
    ImagePicker imagePicker = ImagePicker();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      final List<XFile> files = await imagePicker.pickMultiImage();

      if (files.isNotEmpty) {
        for (var i = 0; i < files.length; i++) {
          XFile file = files[i];
          Uint8List imageFile = await file.readAsBytes();
          try {
            isUploading = true;
            notifyListeners();

            Reference referenceRoot = FirebaseStorage.instance.ref();
            Reference referenceDirImages = referenceRoot.child('chatImages').child(uid);
            UploadTask uploadTask = referenceDirImages.child('image$i').putData(imageFile);
            TaskSnapshot snap = await uploadTask;
            imageUrl = await snap.ref.getDownloadURL();
            imageUrls.add(imageUrl);
          } catch (error) {
            print('$error');
          }
        }
      }
    }
  }
}
