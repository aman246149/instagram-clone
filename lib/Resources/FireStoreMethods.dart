import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/Model/Post.dart';
import 'package:instagram_clone/Resources/Storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload a post
  Future<String> uploadPost(
      {required String description,
      required Uint8List file,
      required String uid,
      required username,
      required String profImage}) async {
    String res = "some error occured";

    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);

      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage);

      _firestore.collection("posts").doc(postId).set(post.toJson());

      res="success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId,String uid,List likes) async{
       try{
         if(likes.contains(uid)){
          await  _firestore.collection("posts").doc(postId).update({"likes":FieldValue.arrayRemove([uid])});
         }else{
          await  _firestore.collection("posts").doc(postId).update({"likes":FieldValue.arrayUnion([uid])});
         }
       }catch(e){
         print(e.toString());
       }
  }

  Future<void> postComment(String postId,String uid,String text,String name, String profilePic)async{
    String commentId=Uuid().v1();
      try{
        if(text.isNotEmpty){
          _firestore.collection("posts").doc(postId).collection("comments").doc(commentId).set({
            "postId":postId,
            "uid":uid,
            "text":text,
            "name":name,
            "profilePic":profilePic
          });
        }else{
          print("empty string");
        }
      }catch(e){
        print(e.toString());
      }
  }

  //delete a post

Future<void> deletePost(String postId) async{
    try{
      await _firestore.collection("posts").doc(postId).delete();
    }catch(e){
      print(e.toString());
    }
}

//follow or unfllow a user

Future<void> followUser(String uid,String followId) async{
      try{
        DocumentSnapshot snap= await FirebaseFirestore.instance.collection("users").doc(uid).get();

        List following=(snap.data()! as dynamic)["following"];

        if(following.contains(followId)){  // unfollow the user
            await FirebaseFirestore.instance.collection("users").doc(followId).update(
                {"followers":FieldValue.arrayRemove([uid])
                });
            await FirebaseFirestore.instance.collection("users").doc(uid).update(
                {"following":FieldValue.arrayRemove([followId])
                });

        }else{
          await FirebaseFirestore.instance.collection("users").doc(followId).update(
              {"followers":FieldValue.arrayUnion([uid])
              });
          await FirebaseFirestore.instance.collection("users").doc(uid).update(
              {"following":FieldValue.arrayUnion([followId])
              });

        }

      }catch(e){
              print(e.toString());
      }
}
}
