import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/components/MyTextField.dart';
import 'package:fumo/components/chat_bubble.dart';
import 'package:fumo/core/di/injection.dart';
import 'package:fumo/core/theme/chat_theme_local_storage.dart';
import 'package:fumo/core/theme/chat_theme_provider.dart';
import 'package:fumo/domain/entities/chat_theme_entity.dart';
import 'package:fumo/domain/entities/message_entity.dart';
import 'package:fumo/domain/repositories/chat_repository.dart';
import 'package:fumo/extensions/context_extensions.dart';
import 'package:fumo/presentation/blocs/auth/auth_bloc.dart';
import 'package:fumo/presentation/blocs/chat/chat_bloc.dart';
import 'package:fumo/presentation/widgets/chat_theme_editor_sheet.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.receiverEmail, required this.receiverId, this.receiverNickname, this.receiverBio, this.receiverAvatarUrl, this.receiverPhone});
  final String receiverEmail;
  final String receiverId;
  final String? receiverNickname;
  final String? receiverBio;
  final String? receiverAvatarUrl;
  final String? receiverPhone;
  String get _displayName {
    if (receiverNickname != null && receiverNickname!.trim().isNotEmpty) return receiverNickname!.trim();
    if (receiverEmail.isNotEmpty) return receiverEmail;
    if (receiverPhone != null && receiverPhone!.trim().isNotEmpty) return receiverPhone!.trim();
    return 'Unknown';
  }
  @override State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late final ChatBloc _chatBloc;
  String? _editingMessageId;
  String? _currentUserId;
  StreamSubscription<Map<String, dynamic>?>? _themeSubscription;

  ChatThemeEntity _chatTheme = ChatThemeEntity.defaultTheme();

  String get _chatRoomId {
    if (_currentUserId == null) return '';
    final ids = [_currentUserId!, widget.receiverId]..sort();
    return ids.join('_');
  }

  @override void initState() {
    super.initState();
    _chatBloc = sl<ChatBloc>();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _currentUserId = authState.user.uid;
      _chatBloc.add(ChatStarted(currentUserId: authState.user.uid, otherUserId: widget.receiverId));
    }
    _focusNode.addListener(() { if (_focusNode.hasFocus) Future<void>.delayed(const Duration(milliseconds: 500), _scrollDown); });
    _initThemeSync();
  }

  void _initThemeSync() {
    final roomId = _chatRoomId;
    if (roomId.isEmpty) return;

    ChatThemeLocalStorage.loadThemeForChat(chatRoomId: roomId).then((theme) {
      if (theme != null && mounted) {
        setState(() { _chatTheme = theme; });
      }
    });

    _themeSubscription = sl<ChatRepository>().watchChatTheme(chatRoomId: roomId).listen((themeData) {
      if (themeData != null && mounted) {
        try {
          final theme = ChatThemeEntity.fromMap(themeData);
          setState(() { _chatTheme = theme; });
          ChatThemeLocalStorage.saveThemeForChat(chatRoomId: roomId, theme: theme);
        } catch (_) {}
      }
    });
  }

  @override void dispose() {
    _themeSubscription?.cancel();
    _focusNode.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    _chatBloc.close();
    super.dispose();
  }

  void _scrollDown() { if (!_scrollController.hasClients) return; _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn); }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    if (_editingMessageId != null) {
      _chatBloc.add(ChatUpdateMessageRequested(messageId: _editingMessageId!, newMessage: text));
      _cancelEditing();
    } else {
      _chatBloc.add(ChatSendMessageRequested(text));
      _messageController.clear();
    }
  }

  void _startEditing(String messageId, String currentText) {
    setState(() { _editingMessageId = messageId; });
    _messageController.text = currentText;
    _messageController.selection = TextSelection.fromPosition(TextPosition(offset: currentText.length));
    _focusNode.requestFocus();
  }

  void _cancelEditing() {
    setState(() { _editingMessageId = null; });
    _messageController.clear();
    _focusNode.unfocus();
  }

  Future<void> _saveThemeToFirestore(ChatThemeEntity theme) async {
    final roomId = _chatRoomId;
    if (roomId.isEmpty) return;
    try {
      await sl<ChatRepository>().saveChatTheme(chatRoomId: roomId, themeData: theme.toMap());
    } catch (_) {
      ChatThemeLocalStorage.saveThemeForChat(chatRoomId: roomId, theme: theme);
    }
  }

  void _showThemeEditor() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ChatThemeEditorSheet(
        currentTheme: _chatTheme,
        chatRoomId: _chatRoomId,
        onThemeApplied: (newTheme) {
          setState(() => _chatTheme = newTheme);
          _saveThemeToFirestore(newTheme);
          ChatThemeLocalStorage.saveThemeToProfile(theme: newTheme);
        },
      ),
    );
  }

  @override Widget build(BuildContext context) {
    return ChatThemeProvider(
      theme: _chatTheme,
      child: BlocProvider.value(
        value: _chatBloc,
        child: Scaffold(
          backgroundColor: _chatTheme.backgroundColor,
          appBar: AppBar(
            title: Row(children: [
              CircleAvatar(radius: 18, backgroundColor: Theme.of(context).colorScheme.secondary, backgroundImage: widget.receiverAvatarUrl != null ? NetworkImage(widget.receiverAvatarUrl!) : null, child: widget.receiverAvatarUrl == null ? Icon(Icons.person, size: 18, color: _chatTheme.ownTextColor) : null),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget._displayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: _chatTheme.fontFamily, color: _chatTheme.ownTextColor)),
                if (widget.receiverBio != null && widget.receiverBio!.trim().isNotEmpty) Text(widget.receiverBio!.trim(), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: _chatTheme.ownTextColor.withValues(alpha: 0.7), fontFamily: _chatTheme.fontFamily)),
              ])),
            ]),
            backgroundColor: _chatTheme.appBarColor,
            foregroundColor: _chatTheme.ownTextColor,
            elevation: 0,
            actions: [
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: _chatTheme.ownTextColor),
                onSelected: (value) {
                  if (value == 'theme') _showThemeEditor();
                  if (value == 'reset') {
                    final defaultTheme = ChatThemeEntity.defaultTheme();
                    if (_chatTheme == defaultTheme) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.localizations.alreadyDefaultTheme), duration: const Duration(seconds: 1)));
                      return;
                    }
                    setState(() => _chatTheme = defaultTheme);
                    _saveThemeToFirestore(defaultTheme);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'theme', child: ListTile(leading: const Icon(Icons.palette), title: Text(context.localizations.changeChatTheme), dense: true)),
                  PopupMenuItem(value: 'reset', child: ListTile(leading: const Icon(Icons.format_paint), title: Text(context.localizations.resetTheme), dense: true)),
                ],
              ),
            ],
          ),
          body: Column(children: [
            Expanded(child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
              if (state is ChatError) return Center(child: Text(state.message));
              if (state is ChatLoading || state is ChatInitial) return Center(child: Text(context.localizations.loading));
              if (state is! ChatLoaded) return const SizedBox.shrink();
              WidgetsBinding.instance.addPostFrameCallback((_) { _scrollDown(); });

              return ListView.builder(
                controller: _scrollController,
                itemCount: state.messages.length,
                itemBuilder: (context, index) => _MessageItem(
                  message: state.messages[index],
                  currentUserId: state.currentUserId,
                  editingMessageId: _editingMessageId,
                  onCopy: () => _copyMessage(state.messages[index].message),
                  onDelete: state.messages[index].senderId == state.currentUserId ? () => _deleteMessage(state.messages[index]) : null,
                  onEdit: state.messages[index].senderId == state.currentUserId ? () => _startEditing(state.messages[index].id!, state.messages[index].message) : null,
                ),
              );
            })),
            if (_editingMessageId != null)
              Container(
                color: _chatTheme.ownBubbleColor.withValues(alpha: 0.3),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(children: [
                  Icon(Icons.edit, size: 16, color: _chatTheme.ownTextColor),
                  const SizedBox(width: 8),
                  Expanded(child: Text(context.localizations.editingMessage, style: TextStyle(fontSize: 12, color: _chatTheme.ownTextColor))),
                  GestureDetector(onTap: _cancelEditing, child: Icon(Icons.close, size: 18, color: _chatTheme.ownTextColor)),
                ]),
              ),
            Padding(padding: const EdgeInsets.only(bottom: 50), child: Row(children: [
              Expanded(child: MyTextField(focusNode: _focusNode, hintText: '...', Obscure: false, controller: _messageController)),
              IconButton(onPressed: _sendMessage, icon: Icon(_editingMessageId != null ? Icons.check : Icons.arrow_upward, color: _chatTheme.ownTextColor)),
            ])),
          ]),
        ),
      ),
    );
  }

  void _copyMessage(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.localizations.messageCopied), duration: const Duration(seconds: 2)));
  }

  void _deleteMessage(MessageEntity message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.localizations.deleteMessage),
        content: Text(context.localizations.deleteMessageConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.localizations.cancel)),
          TextButton(onPressed: () { Navigator.pop(ctx); if (message.id != null) { _chatBloc.add(ChatDeleteMessageRequested(message.id!)); } }, child: Text(context.localizations.delete, style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}

class _MessageItem extends StatelessWidget {
  const _MessageItem({required this.message, required this.currentUserId, this.editingMessageId, this.onCopy, this.onDelete, this.onEdit});
  final MessageEntity message;
  final String currentUserId;
  final String? editingMessageId;
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override Widget build(BuildContext context) {
    final isCurrentUser = message.senderId == currentUserId;
    final alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(alignment: alignment, child: Column(crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
      ChatBubble(isCurrentUser: isCurrentUser, message: message.message, timeStamp: message.timestamp, isEncrypted: message.isEncrypted, isEditing: message.id != null && message.id == editingMessageId, onCopy: onCopy, onDelete: onDelete, onEdit: onEdit),
    ]));
  }
}
