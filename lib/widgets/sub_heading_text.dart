import 'package:flutter/material.dart';

class SubHeadingText extends StatelessWidget {
  final String text;
  final double textSize;
  const SubHeadingText({required this.text, required this.textSize, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textScaleFactor: 1,
        style: TextStyle(
          fontSize: textSize,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
