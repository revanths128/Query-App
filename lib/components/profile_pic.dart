import 'package:flutter/material.dart';
import 'package:question_and_answer/components/circle_image.dart';

class ProfilePic extends StatelessWidget {

  ProfilePic({required this.onPress, required this.image});

  final void Function() onPress;
  final CircleAvatar image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          image,
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  primary: Colors.white,
                ),
                onPressed: onPress,
                child: Icon(
                  Icons.camera_enhance,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
