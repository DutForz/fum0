import 'package:flutter/material.dart';
import 'package:fumo/core/auth/auth_service.dart';
import 'package:fumo/core/chat/chat_service.dart';

class chat_Screan extends StatelessWidget {
  final String receiverEmai, recieverID;

  chat_Screan({
    super.key,
    required this.receiverEmai,
    required this.recieverID,
  });
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(recieverID, _messageController.text);
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receiverEmai)),
      body: Column(children: [Expanded(child: _buildMessageList())]),
    );
  }

  Widget _buildMessageList() {}
}
