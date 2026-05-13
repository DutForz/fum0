import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isCurrentUser,
    required this.message,
  });
  final String message;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(message),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
    );
  }
}
