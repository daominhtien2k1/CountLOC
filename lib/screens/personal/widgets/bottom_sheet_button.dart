import 'package:flutter/material.dart';

class BottomSheetButton extends StatelessWidget {
  final IconData icon;
  final String buttonText;
  final void Function()? onPressed;

  const BottomSheetButton({Key? key,
    required this.icon,
    required this.buttonText,
    required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: 45.0,
                height: 45.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: Icon(
                  icon,
                  size: 20.0,
                )),
            SizedBox(width: 15.0),
            Text(buttonText,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
