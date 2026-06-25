import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String lastMessage;
  final String? avatarUrl;
  final void Function()? onTap;
  const UserTile({super.key, required this.onTap, required this.text, required this.lastMessage, this.avatarUrl});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(70)),
        padding: const EdgeInsets.all(10), margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Row(children: [
          CircleAvatar(radius: 24, backgroundColor: Theme.of(context).colorScheme.surface, backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null, child: avatarUrl == null ? Icon(Icons.person, color: Theme.of(context).colorScheme.inversePrimary) : null),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ])),
        ]),
      ),
    );
  }
}
