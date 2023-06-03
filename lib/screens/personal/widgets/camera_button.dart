import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18.0,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 16.0,
        backgroundColor: Colors.grey[350],
        child: Icon(Icons.camera_alt, color: Colors.black, size: 20.0,),
      ),
    );
  }
}
