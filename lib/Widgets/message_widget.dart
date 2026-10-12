import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:visit_egypt/Screens/viewImage.dart';
import 'package:visit_egypt/constants/constants.dart';

import '../Models/message_model.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageWidget({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          message.urlAvatar == null
              ? CircleAvatar(radius: 16, child: Icon(Icons.person))
              : CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(message.urlAvatar!)),
        message.username == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(message.username!),
              ),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 140),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[100] : primaryColor,
            borderRadius: isMe
                ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
          ),
          child: buildMessage(context),
        ),
      ],
    );
  }

  Widget buildMessage(context) => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          message.type!.contains("img")
              ? InkWell(
                child: Container(
                  width: 100,
                  child: CachedNetworkImage(
                    imageUrl: message.message,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    ),
                  ),
                ),
            onTap: (){
              // showDialog(context: context, builder: (BuildContext context){
              //   return AlertDialog(
              //     content: Image.network(message.message),
              //   );
              // });
              // FullScreenWidget(
              //   child: Hero(
              //     tag: "customTag",
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(16),
              //       child: Image.network(
              //         message.message,
              //         fit: BoxFit.cover,
              //       ),
              //     ),
              //   ),
              // );
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewImage(message.message)));
            },
              )
              : Text(
                  message.message,
                  style: TextStyle(color: isMe ? Colors.black : Colors.white),
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
        ],
      );
}
