import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fumo/components/MyTextField.dart';

import 'package:fumo/components/chat_bubble.dart';

import 'package:fumo/core/di/injection.dart';

import 'package:fumo/domain/entities/message_entity.dart';

import 'package:fumo/extensions/context_extensions.dart';

import 'package:fumo/presentation/blocs/auth/auth_bloc.dart';

import 'package:fumo/presentation/blocs/chat/chat_bloc.dart';



class ChatScreen extends StatefulWidget {

  const ChatScreen({

    super.key,

    required this.receiverEmail,

    required this.receiverId,

    this.receiverNickname,

    this.receiverBio,

    this.receiverAvatarUrl,

  });



  final String receiverEmail;

  final String receiverId;

  final String? receiverNickname;

  final String? receiverBio;

  final String? receiverAvatarUrl;



  String get _displayName {

    if (receiverNickname != null && receiverNickname!.trim().isNotEmpty) {

      return receiverNickname!.trim();

    }

    return receiverEmail;

  }



  @override

  State<ChatScreen> createState() => _ChatScreenState();

}



class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController _messageController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  late final ChatBloc _chatBloc;



  @override

  void initState() {

    super.initState();

    _chatBloc = sl<ChatBloc>();

    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated) {

      _chatBloc.add(

        ChatStarted(

          currentUserId: authState.user.uid,

          otherUserId: widget.receiverId,

        ),

      );

    }

    _focusNode.addListener(() {

      if (_focusNode.hasFocus) {

        Future<void>.delayed(

          const Duration(milliseconds: 500),

          _scrollDown,

        );

      }

    });

  }



  @override

  void dispose() {

    _focusNode.dispose();

    _messageController.dispose();

    _scrollController.dispose();

    _chatBloc.close();

    super.dispose();

  }



  void _scrollDown() {

    if (!_scrollController.hasClients) {

      return;

    }

    _scrollController.animateTo(

      _scrollController.position.maxScrollExtent,

      duration: const Duration(seconds: 1),

      curve: Curves.fastOutSlowIn,

    );

  }



  void _sendMessage() {

    final message = _messageController.text;

    if (message.isEmpty) {

      return;

    }

    _chatBloc.add(ChatSendMessageRequested(message));

    _messageController.clear();

  }



  @override

  Widget build(BuildContext context) {

    return BlocProvider.value(

      value: _chatBloc,

      child: Scaffold(

        appBar: AppBar(

          title: Row(

            children: [

              CircleAvatar(

                radius: 18,

                backgroundColor: Theme.of(context).colorScheme.secondary,

                backgroundImage: widget.receiverAvatarUrl != null

                    ? NetworkImage(widget.receiverAvatarUrl!)

                    : null,

                child: widget.receiverAvatarUrl == null

                    ? Icon(

                        Icons.person,

                        size: 18,

                        color: Theme.of(context).colorScheme.inversePrimary,

                      )

                    : null,

              ),

              const SizedBox(width: 12),

              Expanded(

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(

                      widget._displayName,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                    ),

                    if (widget.receiverBio != null &&

                        widget.receiverBio!.trim().isNotEmpty)

                      Text(

                        widget.receiverBio!.trim(),

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(

                          fontSize: 12,

                          color: Theme.of(context)

                              .colorScheme

                              .inversePrimary

                              .withValues(alpha: 0.7),

                        ),

                      ),

                  ],

                ),

              ),

            ],

          ),

          backgroundColor: Theme.of(context).colorScheme.surface,

          foregroundColor: Theme.of(context).colorScheme.inversePrimary,

          elevation: 0,

        ),

        body: Column(

          children: [

            Expanded(

              child: BlocBuilder<ChatBloc, ChatState>(

                builder: (context, state) {

                  if (state is ChatError) {

                    return Center(child: Text(state.message));

                  }

                  if (state is ChatLoading || state is ChatInitial) {

                    return Center(

                      child: Text(context.localizations.loading),

                    );

                  }

                  if (state is! ChatLoaded) {

                    return const SizedBox.shrink();

                  }



                  WidgetsBinding.instance.addPostFrameCallback((_) {

                    _scrollDown();

                  });



                  return ListView.builder(

                    controller: _scrollController,

                    itemCount: state.messages.length,

                    itemBuilder: (context, index) {

                      return _MessageItem(

                        message: state.messages[index],

                        currentUserId: state.currentUserId,

                      );

                    },

                  );

                },

              ),

            ),

            Padding(

              padding: const EdgeInsets.only(bottom: 50),

              child: Row(

                children: [

                  Expanded(

                    child: MyTextField(

                      focusNode: _focusNode,

                      hintText: '...',

                      Obscure: false,

                      controller: _messageController,

                    ),

                  ),

                  IconButton(

                    onPressed: _sendMessage,

                    icon: const Icon(Icons.arrow_upward),

                  ),

                ],

              ),

            ),

          ],

        ),

      ),

    );

  }

}



class _MessageItem extends StatelessWidget {

  const _MessageItem({

    required this.message,

    required this.currentUserId,

  });



  final MessageEntity message;

  final String currentUserId;



  @override

  Widget build(BuildContext context) {

    final isCurrentUser = message.senderId == currentUserId;

    final alignment =

        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;



    return Container(

      alignment: alignment,

      child: Column(

        crossAxisAlignment: isCurrentUser

            ? CrossAxisAlignment.end

            : CrossAxisAlignment.start,

        children: [

          ChatBubble(

            isCurrentUser: isCurrentUser,

            message: message.message,

            timeStamp: message.timestamp,

          ),

        ],

      ),

    );

  }

}


