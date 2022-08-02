import 'package:flutter/material.dart';

class VerticalSizedBox extends StatelessWidget {
  final double height;
  const VerticalSizedBox({required this.height, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class HorizontalSizedBox extends StatelessWidget {
  final double width;
  const HorizontalSizedBox({required this.width, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
