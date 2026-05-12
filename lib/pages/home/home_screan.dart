import 'package:flutter/material.dart';
import 'package:fumo/components/MyDrawer.dart';
import 'package:fumo/components/User_Tile.dart';
import 'package:fumo/core/auth/auth_service.dart';
import 'package:fumo/core/chat/chat_service.dart';
import 'package:fumo/extensions/context_extensions.dart';
import 'package:fumo/pages/chat/chat_Screan.dart';

class HomeScrean extends StatelessWidget {
  HomeScrean({super.key});
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizations.home),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      drawer: Mydrawer(selectedLocale: Locale('en')),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Text(context.localizations.error);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(context.localizations.loading);
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      }),
    );
  }

  Widget _buildUserListItem(
    Map<String, dynamic> UserData,
    BuildContext context,
  ) {
    if (UserData["email"] != _authService.getCurrentUSer()) {
      return UserTile(
        text: UserData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  chat_Screan(receiverEmai: UserData["email"]),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
