import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/components/MyDrawer.dart';
import 'package:fumo/components/User_Tile.dart';
import 'package:fumo/core/di/injection.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/usecases/chat/get_last_message.dart';
import 'package:fumo/extensions/context_extensions.dart';
import 'package:fumo/presentation/blocs/home/home_bloc.dart';
import 'package:fumo/presentation/pages/chat/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override void initState() { super.initState(); context.read<HomeBloc>().add(const HomeStarted()); _searchController.addListener(_onSearchChanged); }
  @override void dispose() { _searchController.dispose(); super.dispose(); }
  void _onSearchChanged() { context.read<HomeBloc>().add(HomeSearchQueryChanged(_searchController.text)); }
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(controller: _searchController, decoration: InputDecoration(hintText: context.localizations.home, border: InputBorder.none, hintStyle: const TextStyle(fontSize: 20)), style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: Mydrawer(selectedLocale: const Locale('en')),
      body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is HomeError) return Center(child: Text(state.message));
        if (state is HomeLoading || state is HomeInitial) return Center(child: Text(context.localizations.loading));
        if (state is! HomeLoaded) return const SizedBox.shrink();
        if (state.isSearching) return Center(child: Text(context.localizations.loading));
        final users = state.displayedUsers;
        if (users.isEmpty) return const SizedBox.shrink();
        return ListView(children: users.map((user) => _UserListItem(user: user, currentUserId: state.currentUser.uid)).toList());
      }),
    );
  }
}

class _UserListItem extends StatelessWidget {
  const _UserListItem({required this.user, required this.currentUserId});
  final UserEntity user;
  final String currentUserId;
  @override Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: sl<GetLastMessage>()(GetLastMessageParams(currentUserId: currentUserId, otherUserId: user.uid)),
      builder: (context, snapshot) => UserTile(text: user.displayName, avatarUrl: user.avatarUrl, lastMessage: snapshot.data ?? '', onTap: () { Navigator.push(context, MaterialPageRoute<void>(builder: (context) => ChatScreen(receiverEmail: user.email, receiverId: user.uid, receiverNickname: user.nickname, receiverBio: user.bio, receiverAvatarUrl: user.avatarUrl, receiverPhone: user.phone))); }),
    );
  }
}
