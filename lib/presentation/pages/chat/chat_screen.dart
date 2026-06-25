import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/components/MyTextField.dart';
import 'package:fumo/components/chat_bubble.dart';
import 'package:fumo/core/di/injection.dart';
import 'package:fumo/domain/entities/message_entity.dart';
import 'package:fumo/extensions/context_extensions.dart';
import 'package:fumo/presentation/blocs/auth/auth_bloc.dart';
import 'package:fumo/presentation/blocs/chat/chat_bloc.dart';

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

  @override void initState() {
    super.initState();
    _chatBloc = sl<ChatBloc>();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) _chatBloc.add(ChatStarted(currentUserId: authState.user.uid, otherUserId: widget.receiverId));
    _focusNode.addListener(() { if (_focusNode.hasFocus) Future<void>.delayed(const Duration(milliseconds: 500), _scrollDown); });
  }
  @override void dispose() { _focusNode.dispose(); _messageController.dispose(); _scrollController.dispose(); _chatBloc.close(); super.dispose(); }
  void _scrollDown() { if (!_scrollController.hasClients) return; _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn); }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    if (_editingMessageId != null) {
      // Save edited message
      _chatBloc.add(ChatUpdateMessageRequested(messageId: _editingMessageId!, newMessage: text));
      _cancelEditing();
    } else {
      // Send new message
      _chatBloc.add(ChatSendMessageRequested(text));
      _messageController.clear();
    }
  }

  void _startEditing(String messageId, String currentText) {
    setState(() {
      _editingMessageId = messageId;
    });
    _messageController.text = currentText;
    _messageController.selection = TextSelection.fromPosition(TextPosition(offset: currentText.length));
    _focusNode.requestFocus();
  }

  void _cancelEditing() {
    setState(() {
      _editingMessageId = null;
    });
    _messageController.clear();
    _focusNode.unfocus();
  }

  @override Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            CircleAvatar(radius: 18, backgroundColor: Theme.of(context).colorScheme.secondary, backgroundImage: widget.receiverAvatarUrl != null ? NetworkImage(widget.receiverAvatarUrl!) : null, child: widget.receiverAvatarUrl == null ? Icon(Icons.person, size: 18, color: Theme.of(context).colorScheme.inversePrimary) : null),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget._displayName, maxLines: 1, overflow: TextOverflow.ellipsis),
              if (widget.receiverBio != null && widget.receiverBio!.trim().isNotEmpty) Text(widget.receiverBio!.trim(), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.7))),
            ])),
          ]),
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 0,
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
          // Edit mode indicator + input field
          if (_editingMessageId != null)
            Container(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Editing message', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary))),
                  GestureDetector(
                    onTap: _cancelEditing,
                    child: Icon(Icons.close, size: 18, color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          Padding(padding: const EdgeInsets.only(bottom: 50), child: Row(children: [
            Expanded(child: MyTextField(focusNode: _focusNode, hintText: '...', Obscure: false, controller: _messageController)),
            IconButton(
              onPressed: _sendMessage,
              icon: Icon(_editingMessageId != null ? Icons.check : Icons.arrow_upward),
            ),
          ])),
        ]),
      ),
    );
  }

  void _copyMessage(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message copied to clipboard'), duration: Duration(seconds: 2)),
    );
  }

  void _deleteMessage(MessageEntity message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (message.id != null) {
                _chatBloc.add(ChatDeleteMessageRequested(message.id!));
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _MessageItem extends StatelessWidget {
  const _MessageItem({
    required this.message,
    required this.currentUserId,
    this.editingMessageId,
    this.onCopy,
    this.onDelete,
    this.onEdit,
  });
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
      ChatBubble(
        isCurrentUser: isCurrentUser,
        message: message.message,
        timeStamp: message.timestamp,
        isEncrypted: message.isEncrypted,
        isEditing: message.id != null && message.id == editingMessageId,
        onCopy: onCopy,
        onDelete: onDelete,
        onEdit: onEdit,
      ),
    ]));
  }
}
