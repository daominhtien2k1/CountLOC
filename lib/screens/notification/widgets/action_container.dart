import 'package:flutter/material.dart';

class ActionContainer extends StatelessWidget {
  final String action;
  const ActionContainer(
      {Key? key,
      required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch(action)
    {
      case "like":
        return Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
                color: Colors.blue, shape: BoxShape.circle),
            child: Center(
                child: Icon(Icons.thumb_up, color: Colors.white, size: 20)));
      case "comment":
        return Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
                color: Colors.lightGreen, shape: BoxShape.circle),
            child: Center(
                child: Icon(Icons.comment, color: Colors.white, size: 20)));
      default:
        return Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
                color: Colors.blue, shape: BoxShape.circle),
            child: Center(
                child: Icon(Icons.facebook, color: Colors.white, size: 20)));
    }

}}