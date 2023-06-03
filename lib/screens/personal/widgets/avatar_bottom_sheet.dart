import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'bottom_sheet_button.dart';

class AvatarBottomSheet extends StatelessWidget {
  const AvatarBottomSheet({Key? key}) : super(key: key);

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
              buttonText: "Xem ảnh đại diện",
              onPressed: () => print('Xem ảnh đại diện')),
          BottomSheetButton(
              icon: MdiIcons.fileImagePlus,
              buttonText: "Chọn ảnh đại diện",
              onPressed: () => print('Chọn ảnh đại diện'))
        ],
      ),
    );
  }
}
