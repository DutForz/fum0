import 'package:flutter/material.dart';
import 'package:fumo/components/MyDrawer.dart';
import 'package:fumo/components/User_Tile.dart';
import 'package:fumo/core/auth/auth_service.dart';
import 'package:fumo/core/chat/chat_service.dart';
import 'package:fumo/core/search/search_service.dart';
import 'package:fumo/extensions/context_extensions.dart';
import 'package:fumo/pages/chat/chat_Screan.dart';

class HomeScrean extends StatelessWidget {
  HomeScrean({super.key});
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final SearchService _searchService = SearchService();
  final TextEditingController _searchController = TextEditingController();
  void search() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: context.localizations.home,
            border: InputBorder.none,
            hintStyle: TextStyle(fontSize: 20),
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        actions: [IconButton(onPressed: search, icon: Icon(Icons.search))],
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
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
      return StreamBuilder<String?>(
        stream: _chatService.getLastMessage(
          _authService.getCurrentUSer()!.uid,
          UserData["uid"],
        ),
        builder: (context, snapshot) {
          String? lastMessage = snapshot.data;
          if (_searchController.text != "") {
            _searchService.searchEmail(_searchController.text);
            return UserTile(
              text: UserData["email"],
              lastMessage: lastMessage ?? "",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => chat_Screan(
                      receiverEmai: UserData["email"],
                      recieverID: UserData["uid"],
                    ),
                  ),
                );
              },
            );
          }
          if (lastMessage != null) {
            return UserTile(
              text: UserData["email"],
              lastMessage: lastMessage ?? "",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => chat_Screan(
                      receiverEmai: UserData["email"],
                      recieverID: UserData["uid"],
                    ),
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
      );
    } else {
      return Container();
    }
  }
}
