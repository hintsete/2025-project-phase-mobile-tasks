import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final String type;
  final bool isMe;

  const MessageBubble({
    Key? key,
    required this.content,
    required this.type,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (type == "image") {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(content, width: 200),
      );
    } else if (type == "audio") {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow, color: isMe ? Colors.white : Colors.black),
          Text("00:16", style: TextStyle(color: isMe ? Colors.white : Colors.black)),
        ],
      );
    } else {
      child = Text(
        content,
        style: TextStyle(color: isMe ? Colors.white : Colors.black),
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}
