import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {

  CircleImage({this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    return url != null
        ? CircleAvatar(
      backgroundImage: NetworkImage(url!),
    )
        : CircleAvatar(
      backgroundImage: AssetImage("assets/images/profile.jpg"),
    );
  }
}

