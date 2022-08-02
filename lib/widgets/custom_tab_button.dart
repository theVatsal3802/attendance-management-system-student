import 'package:flutter/material.dart';

class CustomTabButton extends StatelessWidget {
  final IconData icon;
  final Widget child;
  final VoidCallback onTap;
  const CustomTabButton(
      {required this.child, required this.icon, Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(
          20,
        ),
      ),
      splashColor: Theme.of(context).colorScheme.primary,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        height: 150,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black45,
              offset: Offset(2, 2),
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.secondary,
              size: 40,
            ),
            child,
          ],
        ),
      ),
    );
  }
}
