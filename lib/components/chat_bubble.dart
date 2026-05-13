import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isCurrentUser,
    required this.message,
    required this.timeStamp,
  });
  final String message;
  final bool isCurrentUser;
  final Timestamp timeStamp;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.background),
          ),
          Text(
            DateFormat('HH:mm').format((timeStamp.toDate()).toLocal()),
            textAlign: TextAlign.left,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? Theme.of(context).colorScheme.inversePrimary
            : Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
    );
  }
}
