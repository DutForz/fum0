import 'package:flutter/material.dart';

class chat_Screan extends StatelessWidget {
  final String receiverEmai;
  const chat_Screan({super.key, required this.receiverEmai});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(receiverEmai)));
  }
}
