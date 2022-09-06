import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {

  IconWidget({required this.icons, required this.onPress});

  final IconData icons;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icons,
        color: Colors.white,
        size: 25.0,
      ),
      onPressed: onPress,
    );
  }
}