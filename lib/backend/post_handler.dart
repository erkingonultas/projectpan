import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:projectpan/backend/auth_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectpan/backend/storage_handler.dart';

import 'models/models.dart';

class PostHandler extends ChangeNotifier {
  //late ImagePicker imagePicker;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Post> _currentPosts = [];
  List<Post> get currentPosts => _currentPosts;

  Future<void> fetchPosts() async {
    notifyListeners();
  }

  imgPicker(ImageSource source) async {
    final ImagePicker _imgPicker = ImagePicker();

    XFile? _file = await _imgPicker.pickImage(source: source);

    if (_file != null) {
      Uint8List _selected = await _file.readAsBytes();
      // compressing image before upload
      return await testComporessList(_selected);
    } else {
      if (kDebugMode) {
        print('Image selection cancelled.');
      }
    }
  }

  // UPLOAD POST
  Future<String> uploadPost(String caption, Uint8List art, String uid,
      String userName, String userPicUrl) async {
    String res = 'unknown error';
    try {
      //uploading image
      String postArtUrl =
          await StorageHandler().uploadImageToStorage('posts', art, true);
      String postId = const Uuid().v1();
      Post post = Post(
        postId: postId,
        userId: uid,
        userPicUrl: userPicUrl,
        datePublished: DateFormat.yMMMd().format(DateTime.now()),
        songId: '0',
        postDesc: caption,
        postArt: postArtUrl,
        likes: [],
        userName: userName,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      //_firestore.collection('users').doc(uid).collection('userPostIds').doc(postId).set({'postId': postId});
      res = 'post successful';
    } catch (e) {
      res = e.toString();
      if (kDebugMode) {
        print(res);
      }
    }
    return res;
  }

  // LIKE POST
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  // COMMENT ON A POST
  Future<String> postComment(
      String postId, String text, String userUid, String name) async {
    String res = 'unknown error';
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'text': text,
          'userUid': userUid,
          'name': name,
          'datePublished': DateFormat.yMMMd().format(DateTime.now()),
        });
        res = 'post successful';
      } else {
        res = 'error';
        if (kDebugMode) {
          print('Text is empty');
        }
      }
    } catch (e) {
      res = e.toString();
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return res;
  }

  // DELETE A POST
  Future<String> deletePost(String postId) async {
    String res = 'unknown error';
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'successful';
    } catch (e) {
      res = e.toString();
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return res;
  }

  // FOLLOW
  Future<String> followUser(String uid, String followId) async {
    String res = 'unknown error';
    try {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _firestore.collection('users').doc(uid).get();
      List following = snap.data()!['following'];
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
        res = 'unfollowed';
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
        res = 'followed';
      }
    } catch (e) {
      res = e.toString();
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return res;
  }
}

class AccountInfoHandler extends ChangeNotifier {
  final AuthHandler _authHandler = AuthHandler();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  bool isloggedIn = false;

  Profile? _profile;

  Profile get profile =>
      _profile ??
      const Profile(
        userId: 'userId',
        userName: 'userName',
        userMail: 'userMail',
        userPicUrl:
            'https://firebasestorage.googleapis.com/v0/b/projectpan-a30c5.appspot.com/o/profilePics%2FdefaultUser.png?alt=media&token=acfb4caa-b1b6-4d4a-961b-57f7cbc449b4',
        joinDate: 'joinDate',
        followers: [],
        following: [],
      );

  void initAccountInfo() async {
    _listenForChangesInAuth();
  }

  _listenForChangesInAuth() {
    FirebaseAuth.instance.idTokenChanges().listen((User? user) async {
      // if (user != null) {
      //   isloggedIn = true;
      //   notifyListeners();
      //   _profile = await _authHandler.getUserDetails();
      // } else {
      //   isloggedIn = false;
      //   notifyListeners();
      // }
      // print(isloggedIn);
    }).onData((data) {
      if (data != null) {
        isloggedIn = true;
      } else {
        isloggedIn = false;
      }
      notifyListeners();
    });
  }

  void setUpAccount() async {
    _profile = await _authHandler.getUserDetails();
    notifyListeners();
  }
}

Future<Uint8List> testComporessList(Uint8List list) async {
  var result = await FlutterImageCompress.compressWithList(
    list,
    minHeight: 1080,
    minWidth: 1080,
    quality: 95,
    rotate: 0,
  );
  return result;
}
