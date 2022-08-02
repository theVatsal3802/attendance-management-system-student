import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  final double textSize;
  final String text;
  const HeadingText({required this.text, required this.textSize, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaleFactor: 1,
      style: TextStyle(
        fontSize: textSize,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
