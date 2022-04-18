import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Resources/Auth_methods.dart';
import 'package:instagram_clone/Resources/FireStoreMethods.dart';
import 'package:instagram_clone/Screens/Login_Screen.dart';
import 'package:instagram_clone/Widgets/FollowButton.dart';
import 'package:instagram_clone/utils/colors.dart';

class UserScreen extends StatefulWidget {
  final String uid;
  const UserScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var userdata={};
  var postlen=0;
  int followerslen=0;
  int followinglen=0;
  bool isFollowing=false;
  bool isLoading=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  void getdata()async{
    setState(() {
      isLoading=true;
    });
    var data=await FirebaseFirestore.instance.collection("users").doc(widget.uid).get();
    var postsnap= await FirebaseFirestore.instance.collection("posts").where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    postlen=postsnap.docs.length;
    userdata=data.data()!;
    followerslen=data.data()!["followers"].length;
    followinglen=data.data()!["following"].length;
    isFollowing=data.data()!["followers"].contains(FirebaseAuth.instance.currentUser!.uid);
    setState(() {

    });

    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  isLoading==true?const Center(child: CircularProgressIndicator(),):Scaffold(
      appBar: AppBar(title: Text(userdata["username"]),
      backgroundColor: mobileBackgroundColor,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 40,backgroundColor: Colors.white,backgroundImage: NetworkImage(userdata["photoUrl"]),),
                  
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildCustomColumn(postlen, "posts"),
                            buildCustomColumn(followerslen, "followers"),
                            buildCustomColumn(followinglen, "following"),
                          ],
                  ),

                        FirebaseAuth.instance.currentUser!.uid==widget.uid?
                        FollowButton(
                          backgroundColor:mobileBackgroundColor,
                          text: "Sign out",
                          borderColor:Colors.grey ,
                          textColor: primaryColor,
                          function: ()async{
                                  await Auth_Methods().signOut();
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login_Screen(),));
                          },

                        ):isFollowing? FollowButton(
                          backgroundColor:Colors.white,
                          text: "unfollow",
                          borderColor:Colors.grey ,
                          textColor: Colors.black,
                          function: () async{
                            await FireStoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userdata["uid"]);
                            setState(() {
                              isFollowing=false;
                              followerslen--;
                            });
                          },

                        ):FollowButton(
                          backgroundColor:Colors.blue,
                          text: "follow",
                          borderColor:Colors.blue ,
                          textColor: Colors.white,
                          function: () async{
                            await FireStoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userdata["uid"]);

                            setState(() {
                              isFollowing=true;
                              followerslen++;
                            });
                          },

                        )

                      ],
                    ),
                  )
                ],
              ),

              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 15),
                child: Text(userdata["username"],style: TextStyle(fontWeight: FontWeight.bold),),
              ), Container(
                alignment: Alignment.centerLeft,
                padding:const EdgeInsets.only(top: 15),
                child: Text(userdata["bio"],style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              const Divider(),

              FutureBuilder(
                future: FirebaseFirestore.instance.collection("posts").where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
                builder: (context , snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);

                  }
                  return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data as dynamic).docs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 5,mainAxisSpacing: 1.5,childAspectRatio: 1),

                      itemBuilder: (context,index){
                       var snap= (snapshot.data! as dynamic).docs[index];

                       return Container(
                         child: Image(
                           fit: BoxFit.cover,
                           image: NetworkImage((snap ["postUrl"]),
                         ),
                       )
                       );
                      }

                      );
                },
              ),
            ],
        ),
      ),
    );
  }
  
  Column buildCustomColumn(int numb,String text){
    return Column(
      children: [
        Text(numb.toString(),style: TextStyle(fontSize: 18),),
        Text(text,style: TextStyle(fontSize: 15),)
      ],
    );
  }
}
