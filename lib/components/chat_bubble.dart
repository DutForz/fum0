import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.isCurrentUser, required this.message, required this.timeStamp});
  final String message;
  final bool isCurrentUser;
  final DateTime timeStamp;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.inversePrimary, borderRadius: BorderRadius.circular(50)),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Column(children: [
        Text(message, style: TextStyle(color: Theme.of(context).colorScheme.surface)),
        Text(DateFormat('HH:mm').format(timeStamp.toLocal()), textAlign: TextAlign.left, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      ]),
    );
  }
}
