import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          CircleAvatar(radius: 16,backgroundColor: Colors.white,backgroundImage: NetworkImage(widget.snap["profilePic"]),),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(text: TextSpan(
                    children: [
                      TextSpan(text: widget.snap["name"],style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: "   ${widget.snap["text"]}"),
                    ]
                  )),
                  Padding(
                      padding: EdgeInsets.only(top: 9),
                    child: Text(DateFormat.yMMMd().format(DateTime.now()),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),

                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
