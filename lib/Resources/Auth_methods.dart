import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Model/User.dart' as model;
import 'package:instagram_clone/Resources/Storage_methods.dart';

class Auth_Methods {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; //create instance for firebase auth
  final FirebaseFirestore _firestore = FirebaseFirestore
      .instance; // createing instance of firestore  to save data like username or bio

//create a signup method

  Future<String> signUp(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // creating user here and signup user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // cred.user.uid;

        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profilePics", file, false);

        model.User user = model.User(
            email: email,
            bio: bio,
            followers: [],
            following: [],
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            username: username);

        //saving data into firestore
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "succes";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //logging in method

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "please enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<model.User> getUserDetails() async{
    User currentUser=_auth.currentUser!;

    DocumentSnapshot snap=await _firestore.collection("users").doc(currentUser.uid).get();
    return model.User.fromSnap(snap);

  }

  Future<void> signOut() async{
    await _auth.signOut();
  }
}
