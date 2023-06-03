import 'package:flutter/material.dart';

import 'bottom_sheet_button.dart';

class CoverBottomSheet extends StatelessWidget {
  const CoverBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      height: 200.0,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.grey[300],
            ),
            alignment: Alignment.center,
            width: 70.0,
            height: 5.0,
          ),
          const SizedBox(height: 8.0),
          BottomSheetButton(
              icon: Icons.image,
              buttonText: "Xem ảnh bìa",
              onPressed: () => print('Xem ảnh bìa')),
          BottomSheetButton(
              icon: Icons.upload,
              buttonText: "Tải ảnh lên",
              onPressed: () => print('Tải ảnh lên'))
        ],
      ),
    );
  }
}
