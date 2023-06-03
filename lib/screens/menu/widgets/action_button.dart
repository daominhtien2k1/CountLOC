import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String buttonText;
  final void Function()? onPressed;

  const ActionButton(
      {Key? key,
      required this.icon,
      required this.buttonText,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          backgroundColor: Colors.grey[350],
          minimumSize: const Size(double.infinity, 50.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0))),
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Colors.black,
      ),
      label: Text(
        buttonText,
        style: const TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
