import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  const Mybutton({super.key, required this.inSideText, required this.onTap});
  final String inSideText;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(15)),
        width: 150, padding: EdgeInsets.all(25), margin: EdgeInsets.all(25),
        child: Center(child: Text(inSideText)),
      ),
    );
  }
}
