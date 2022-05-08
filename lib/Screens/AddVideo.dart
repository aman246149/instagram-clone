import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Screens/ConfirmVideo.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmVideoScreen(
            file: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  showDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            child: Row(
              children: const [
                Icon(Icons.browse_gallery_outlined),
                SizedBox(
                  width: 10,
                ),
                Text("Gallery"),
              ],
            ),
            onPressed: () {
              pickVideo(ImageSource.gallery, context);
            },
          ),
          SimpleDialogOption(
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                SizedBox(
                  width: 10,
                ),
                Text("Camera"),
              ],
            ),
            onPressed: () {},
          ),
          SimpleDialogOption(
            child: Row(
              children: const [
                Icon(Icons.cancel),
                SizedBox(
                  width: 10,
                ),
                Text("Cancel"),
              ],
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => showDialogBox(context),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Text(
            "Add Video",
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
