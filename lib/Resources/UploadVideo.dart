import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/Model/Video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideo {
  _compressVideo(String videopath) async {
    final compressedVideo = await VideoCompress.compressVideo(videopath,
        quality: VideoQuality.MediumQuality);

    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = FirebaseStorage.instance.ref().child("videos").child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbNail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbNail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref =
        FirebaseStorage.instance.ref().child("thumbnails").child(id);

    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  uploadVideoToFirebase(
      String songName, String caption, String videoPath) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      var allDocs = await FirebaseFirestore.instance.collection("videos").get();
      int len = allDocs.docs.length;

      String videoUrl = await _uploadVideoToStorage("video $len", videoPath);
      String thumbNailUrl =
          await _uploadImageToStorage("video $len", videoPath);

      Video video = Video(
          caption: caption,
          likes: [],
          thumbnail: thumbNailUrl,
          videoUrl: videoUrl,
          id: "Video $len",
          commentCount: 0,
          shareCount: 0,
          uid: uid,
          profilePhoto: (userDoc.data()! as Map<String, dynamic>)['photoUrl'],
          songName: songName,
          username: (userDoc.data()! as Map<String, dynamic>)['userName']);

      await FirebaseFirestore.instance
          .collection('videos')
          .doc('Video $len')
          .set(
            video.toJson(),
          );
    } catch (e) {
      print(e.toString());
    }
  }
}
