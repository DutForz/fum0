import 'package:flutter/material.dart';
import 'package:fumo/components/MyTextField.dart';
import 'package:fumo/components/chat_bubble.dart';
import 'package:fumo/core/auth/auth_service.dart';
import 'package:fumo/core/chat/chat_service.dart';
import 'package:fumo/extensions/context_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/data/latest.dart' as tz;

class chat_Screan extends StatefulWidget {
  final String receiverEmai, recieverID;

  chat_Screan({
    super.key,
    required this.receiverEmai,
    required this.recieverID,
  });

  @override
  State<chat_Screan> createState() => _chat_ScreanState();
}

class _chat_ScreanState extends State<chat_Screan> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.recieverID,
        _messageController.text,
      );
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmai),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUSer()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.recieverID, senderId),
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Text(context.localizations.error);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(context.localizations.loading);
        }
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc))
              .toList(),
        );
      }),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    tz.initializeTimeZones();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUSer()!.uid;
    var alignment = isCurrentUser
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            isCurrentUser: isCurrentUser,
            message: data["message"],
            timeStamp: data["timestamp"],
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              focusNode: myFocusNode,
              hintText: "...",
              Obscure: false,
              controller: _messageController,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}
