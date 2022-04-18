import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Screens/FeedScreen.dart';
import 'package:instagram_clone/Screens/SearchScreen.dart';
import 'package:instagram_clone/Screens/UserScreen.dart';
import 'package:instagram_clone/Screens/postScreen.dart';

const web_Screen_Size=600;

 List<Widget> HomeScreenItems= [
  FeedScreen(),
  SearchScreen(),
  PostScreen(),
  Center(child: Text("Like")),
  UserScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];