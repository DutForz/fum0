import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(70),
        ),
        padding: EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.person),
                    const SizedBox(width: 15),
                    Text(text),
                  ],
                ),

                Text(
                  "test",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
