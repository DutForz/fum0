import 'package:flutter/material.dart';
import 'package:fumo/components/MyDrawer.dart';
import 'package:fumo/components/User_Tile.dart';
import 'package:fumo/core/auth/auth_service.dart';
import 'package:fumo/core/chat/chat_service.dart';
import 'package:fumo/core/search/search_service.dart';
import 'package:fumo/extensions/context_extensions.dart';
import 'package:fumo/pages/chat/chat_Screan.dart';
import 'dart:async';

class HomeScrean extends StatefulWidget {
  HomeScrean({super.key});

  @override
  State<HomeScrean> createState() => _HomeScreanState();
}

class _HomeScreanState extends State<HomeScrean> {
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  final SearchService _searchService = SearchService();
  Timer? _debounceTimer;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
      return;
    }
    setState(() => _isSearching = true);
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    final results = await _searchService.searchEmail(query);
    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

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
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: Mydrawer(selectedLocale: Locale('en')),
      body: GestureDetector(child: _buildUserList()),
    );
  }

  Widget _buildUserList() {
    if (_searchController.text.isNotEmpty) {
      return ListView(
        children: _searchResults
            .map((userData) => _buildUserListItem(userData, context))
            .toList(),
      );
    }
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
        },
      );
    } else {
      return Container();
    }
  }
}
