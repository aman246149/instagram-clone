import 'package:flutter/material.dart';
import 'package:instagram_clone/Resources/Auth_methods.dart';

import '../Model/User.dart';

class UserProvider with ChangeNotifier{
  User? _user;
  final Auth_Methods _auth_methods=Auth_Methods();

  User get getUser=>_user!;

  Future<void> refreshUser() async{
    User user=await _auth_methods.getUserDetails();
    _user=user;
    notifyListeners();
  }
}