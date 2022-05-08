import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Model/Video.dart';
import 'package:instagram_clone/Widgets/VideoScreenWidget.dart';

class VideoFeedScreen extends StatelessWidget {
  const VideoFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection("videos").snapshots(),
      builder: ((context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshots.data!.docs.isEmpty) {
          return const Center(
              child: Text(
            "No Videos Available",
            style: TextStyle(fontSize: 22),
          ));
        }

        return PageView.builder(
          itemCount: snapshots.data!.docs.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final Video data =
                Video.fromSnap(snapshots.data!.docs[index].data());
            final String postId = snapshots.data!.docs[index].id;

            return Stack(
              children: [
                VideoScreenWidget(data: data),
                buildBottomColumn(data),
                rightSideColumn(data, postId, context)
              ],
            );
          },
        );
      }),
    ));
  }

  Align rightSideColumn(Video data, String postId, BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
            ),
            const SizedBox(
              height: 15,
            ),
            IconButton(
                onPressed: () async {
                  if (data.likes
                      .contains(FirebaseAuth.instance.currentUser!.uid)) {
                    //remove our likes
                    await FirebaseFirestore.instance
                        .collection("videos")
                        .doc(postId)
                        .update({
                      'likes': FieldValue.arrayRemove(
                          [FirebaseAuth.instance.currentUser!.uid])
                    });
                  } else {
                    // add our likes
                    await FirebaseFirestore.instance
                        .collection("videos")
                        .doc(postId)
                        .update({
                      'likes': FieldValue.arrayUnion(
                          [FirebaseAuth.instance.currentUser!.uid])
                    });
                  }
                },
                icon: Icon(
                  Icons.favorite,
                  color: data.likes
                          .contains(FirebaseAuth.instance.currentUser!.uid)
                      ? Colors.red
                      : Colors.white,
                )),
            Text(data.likes.length.toString()),
            const SizedBox(
              height: 15,
            ),
            IconButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => CommentScreen(
                  //           postId: data.id,
                  //           profilePhoto: data.profilePhoto,
                  //           username: data.username,
                  //           countComment: data.commentCount,
                  //           ),
                  //     ));
                },
                icon: Icon(
                  Icons.comment,
                  color: Colors.white,
                )),
            Text(data.commentCount.toString()),
            const SizedBox(
              height: 15,
            ),
            const Icon(Icons.replay),
            const Text("0"),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Padding buildBottomColumn(Video data) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8),
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.songName),
              const SizedBox(
                height: 5,
              ),
              Text(data.caption),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const Icon(Icons.music_note), const Text("IDK")],
              )
            ],
          )
        ],
      ),
    );
  }
}
