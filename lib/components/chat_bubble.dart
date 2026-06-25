import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isCurrentUser,
    required this.message,
    required this.timeStamp,
    this.isEncrypted = false,
    this.onDelete,
    this.onEdit,
    this.onCopy,
  });
  final String message;
  final bool isCurrentUser;
  final DateTime timeStamp;
  final bool isEncrypted;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onCopy;

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy message'),
              onTap: () {
                Navigator.pop(context);
                onCopy?.call();
              },
            ),
            if (isCurrentUser)
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit message'),
                onTap: () {
                  Navigator.pop(context);
                  onEdit?.call();
                },
              ),
            if (isCurrentUser)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete message', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  onDelete?.call();
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Column(children: [
          if (isEncrypted)
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.lock, size: 14, color: Theme.of(context).colorScheme.surface),
              const SizedBox(width: 4),
              Text(message, style: TextStyle(color: Theme.of(context).colorScheme.surface)),
            ])
          else
            Text(message, style: TextStyle(color: Theme.of(context).colorScheme.surface)),
          Text(DateFormat('HH:mm').format(timeStamp.toLocal()), textAlign: TextAlign.left, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        ]),
      ),
    );
  }
}
