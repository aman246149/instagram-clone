import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String photoUrl;
  final String uid;
  final String username;
  final String bio;
  final List followers;
  final List following;

  User(
      {required this.email,
      required this.photoUrl,
      required this.username,
      required this.bio,
      required this.followers,
      required this.uid,
      required this.following});

  //method convert class into object

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "uid": uid,
      "email": email,
      "photoUrl": photoUrl,
      "bio": bio,
      "followers": followers,
      "following": following
    };
  }

  //converting object into user
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        email: snapshot['username'],
        photoUrl: snapshot["photoUrl"],
        username: snapshot["username"],
        bio: snapshot["bio"],
        followers: snapshot["followers"],
        uid: snapshot["uid"],
        following: snapshot["following"]);
  }
}
