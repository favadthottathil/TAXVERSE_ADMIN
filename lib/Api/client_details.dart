import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxverse_admin/controller/providers/chatRoom_provider.dart';

getClientDetails() async {
  final CollectionReference gstClientInfoCollection = firestore.collection('ClientDetails');

  QuerySnapshot querySnapshot = await gstClientInfoCollection.get();

  for (var document in querySnapshot.docs) {
    final data = document.data() as Map<String, dynamic>;

   
  }
}
