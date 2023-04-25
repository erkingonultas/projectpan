import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageHandler {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // uploading img to firebase storage
  Future<String> uploadImageToStorage(String childName, Uint8List img, isPost) async {
    // create enum for childName later.
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(img);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Getting user profile pictures
  Future<String> getProfileImg(userUid) async {
    DocumentSnapshot snap = await _firestore.collection('users').doc(userUid).get();
    var snapshot = snap.data() as Map<String, dynamic>;
    String res = '';
    res = snapshot['userPicUrl'];
    return res;
  }
}
