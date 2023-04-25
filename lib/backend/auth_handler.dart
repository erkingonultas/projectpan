import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:projectpan/backend/storage_handler.dart';
import 'constants.dart';
import 'models/models.dart' as models;

class AuthHandler {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<models.Profile> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return models.Profile.fromSnap(snap);
  }

  // sign up
  Future<String> signUpUser({
    required String email,
    required String password, // should be longer than 6 characters
    required String username,
    required Uint8List userPic,
  }) async {
    String res = 'Error occured';
    bool _isClean = true;

    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        if (username.length < 3) {
          res = 'Name must be longer than 5 characters';
        } else if (username.length > 20) {
          res = 'Name must be shorter than 20 characters';
        } else {
          for (String word in profanityFilter) {
            if (username.contains(word)) {
              _isClean = false;
            }
            print('check');
          }

          if (_isClean == false) {
            res = 'Name is invalid';
          } else {
            //register
            UserCredential userCred =
                await _auth.createUserWithEmailAndPassword(
                    email: email, password: password);
            if (kDebugMode) {
              print(userCred.user!.uid);
            }

            String userPicUrl = await StorageHandler()
                .uploadImageToStorage('profilePics', userPic, false);

            // add user info to the database (except password)

            models.Profile user = models.Profile(
              followers: [],
              following: [],
              userId: userCred.user!.uid,
              userMail: email,
              userName: username,
              userPicUrl: userPicUrl,
              joinDate: DateFormat.yMMM().format(DateTime.now()),
            );

            await _firestore
                .collection('users')
                .doc(userCred.user!.uid)
                .set(user.toJson());
            res = 'success';
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = 'Please check your email.';
      } else if (e.code == 'weak-password') {
        res = 'Password should be at least 6 characters.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The email address is already in use by another account.';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  // LOGIN USER
  Future<String> loginUser({
    required String password, // should be longer than 6 characters
    required String email,
  }) async {
    String res = 'Unknown error.';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Success.';
      } else if (email.isEmpty) {
        res = 'Enter your email adress.';
      } else if (password.isEmpty) {
        res = 'Enter your password.';
      } else {
        res = 'Fill in the blanks.';
      }
    }
    //  on FirebaseAuthException catch (e) {
    //   if (e.code == 'wrong-password') {
    //     res = 'Check your password.';
    //   }
    // }
    catch (e) {
      res = e.toString();
      if (res.contains('wrong-password')) {
        res = 'Check your password.';
      } else if (res.contains('unknown')) {
        res = 'Fill in the blanks.';
      }
    }
    if (kDebugMode) {
      print(res);
    }

    return res;
  }

  // LOG OUT
  Future<String> signOut() async {
    String res = 'Unknown error.';
    try {
      await _auth.signOut();
      res = 'successful';
    } catch (e) {
      res = e.toString();
      if (kDebugMode) {
        print(res);
      }
    }
    return res;
  }
}
