import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fumo/core/theme/chat_theme_provider.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isCurrentUser,
    required this.message,
    required this.timeStamp,
    this.isEncrypted = false,
    this.isEditing = false,
    this.onDelete,
    this.onEdit,
    this.onCopy,
  });
  final String message;
  final bool isCurrentUser;
  final DateTime timeStamp;
  final bool isEncrypted;
  final bool isEditing;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onCopy;

  void _showContextMenu(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        isCurrentUser ? offset.dx - 200 : offset.dx + renderBox.size.width + 8,
        offset.dy,
        offset.dx + renderBox.size.width + 200,
        offset.dy + renderBox.size.height,
      ),
      items: [
        const PopupMenuItem(value: 'copy', child: ListTile(leading: Icon(Icons.copy, size: 20), title: Text('Copy'), dense: true, contentPadding: EdgeInsets.zero)),
        if (isCurrentUser) ...[
          const PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit, size: 20), title: Text('Edit'), dense: true, contentPadding: EdgeInsets.zero)),
          const PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete, size: 20, color: Colors.red), title: Text('Delete', style: TextStyle(color: Colors.red)), dense: true, contentPadding: EdgeInsets.zero)),
        ],
      ],
    ).then((value) {
      if (value == 'copy') onCopy?.call();
      if (value == 'edit') onEdit?.call();
      if (value == 'delete') onDelete?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatThemeProvider.of(context);
    final bubbleColor = isCurrentUser ? theme.ownBubbleColor : theme.otherBubbleColor;
    final textColor = isCurrentUser ? theme.ownTextColor : theme.otherTextColor;

    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isEditing
              ? bubbleColor.withValues(alpha: 0.3)
              : bubbleColor,
          borderRadius: BorderRadius.circular(50),
          border: isEditing
              ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
              : null,
        ),
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Column(children: [
          if (isEditing)
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.edit, size: 14, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 4),
              Text(message, style: TextStyle(color: textColor, fontFamily: theme.fontFamily)),
            ])
          else if (isEncrypted)
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.lock, size: 14, color: textColor),
              const SizedBox(width: 4),
              Text(message, style: TextStyle(color: textColor, fontFamily: theme.fontFamily)),
            ])
          else
            Text(message, style: TextStyle(color: textColor, fontFamily: theme.fontFamily)),
          Text(DateFormat('HH:mm').format(timeStamp.toLocal()), textAlign: TextAlign.left, style: TextStyle(color: textColor.withValues(alpha: 0.7))),
        ]),
      ),
    );
  }
}
