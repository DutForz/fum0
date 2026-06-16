import 'package:flutter/material.dart';

class Myicon extends StatelessWidget {
  double width, height;
  final String gif;

  Myicon({super.key, required this.gif, this.width = 300, this.height = 300});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 5,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            widthFactor: 0.8,
            heightFactor: 0.8,
            child: Image.asset(
              'assets/image/$gif',
              width: width,
              height: height,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ),
    );
  }
}
