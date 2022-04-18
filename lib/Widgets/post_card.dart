import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Model/User.dart';
import 'package:instagram_clone/Resources/FireStoreMethods.dart';
import 'package:instagram_clone/Screens/CommentScreen.dart';
import 'package:instagram_clone/Widgets/like_animation.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Providers/user_provider.dart';

class Post_Card extends StatefulWidget {
  final snap;

  const Post_Card({Key? key,required this.snap}) : super(key: key);

  @override
  State<Post_Card> createState() => _Post_CardState();
}

class _Post_CardState extends State<Post_Card> {
  bool isLikeAnimating=false;
  int commentLen=0;


  @override
  void initState() {
    // TODO: implement initState
    getComments();
    super.initState();
  }

  void getComments()async{
    QuerySnapshot  data=  await FirebaseFirestore.instance.collection("posts").doc(widget.snap["postId"]).collection("comments").get();
        setState(() {
          commentLen=data.docs.length;
        });

  }

  @override
  Widget build(BuildContext context) {
  final User user=Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(widget.snap['profImage']),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(widget.snap["username"]),
              )),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: ListView(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  children: ["Delete"]
                                      .map(
                                        (e) => InkWell(
                                          onTap: () async {
                                           await FireStoreMethods().deletePost(widget.snap["postId"]);
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text(e),
                                          ),
                                        ),
                                      )
                                      .toList()),
                            ));
                  },
                  icon: Icon(Icons.more_vert)),
            ],
          ),

          //img section

          GestureDetector(
            onDoubleTap: () async{
             await FireStoreMethods().likePost(widget.snap["postId"], user.uid, widget.snap["likes"]);
              setState(() {
                isLikeAnimating=true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap["postUrl"],
                    fit: BoxFit.cover,
                  ),
                ),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating?1:0,
                  child: LikeAnimation(child: const Icon(Icons.favorite,size: 100,), isAnimating: isLikeAnimating,duration:const  Duration(milliseconds: 400) ,onEnd: (){
                    setState(() {
                      isLikeAnimating=false;
                    });
                  },),
                )
              ],
            ),
          ),

          //Like comment section

          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap["likes"].contains(user.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async{
                      await FireStoreMethods().likePost(widget.snap["postId"], user.uid, widget.snap["likes"]);
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CommentScreen(
                      snap: widget.snap,
                    ),));
                  },
                  icon:const Icon(
                    Icons.comment_outlined,
                  )),
              IconButton(
                  onPressed: () {},
                  icon:const Icon(
                    Icons.send,
                  )),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon:const Icon(Icons.bookmark_border),
                ),
              ))
            ],
          ),

          //Descriptioon and number of comments

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.snap["likes"].length} likes",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                              text: widget.snap["username"],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                 widget.snap["description"])
                        ]),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "view all ${commentLen.toString()} comments",
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(widget.snap["datePublished"].toDate(),),

                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
