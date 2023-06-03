import 'package:flutter/material.dart';

import 'personal_subscreens.dart';

class ProfileSetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Cài đặt trang cá nhân',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              // padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 2.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                    child: _SettingsButton(
                        onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfileScreen()))
                            },
                        icon: Icons.edit_outlined,
                        buttonName: 'Chỉnh sửa trang cá nhân'),
                  ),
                  Divider(height: 0.0, thickness: 0.0),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                    child: _SettingsButton(
                        onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchProfileScreen()))
                            },
                        icon: Icons.search_outlined,
                        buttonName: 'Tìm kiếm trên trang cá nhân'),
                  ),
                  Divider(height: 0.0, thickness: 0.5),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Liên kết đến trang cá nhân của bạn",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text('Liên kết của riêng bạn trên facebook.',
                            style: TextStyle(fontSize: 15.0)),
                        Divider(height: 10.0, thickness: 1.0),
                        Text(
                          'Link facebook o day',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 1.5,
                              color: Colors.black45,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: () => print('Copy'),
                          child: Text(
                            'SAO CHÉP LIÊN KẾT',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final IconData icon;
  final String buttonName;
  final void Function()? onPressed;

  const _SettingsButton(
      {Key? key, required this.icon, required this.buttonName, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: onPressed,
        style: ButtonStyle(
            alignment: Alignment.centerLeft,
            padding: MaterialStateProperty.all(EdgeInsets.all(12.0))),
        icon: Icon(
          icon,
          size: 28.0,
          color: Colors.black,
        ),
        label: Text(
          buttonName,
          style: TextStyle(
              fontSize: 17.0, color: Colors.black, fontWeight: FontWeight.w500),
        ));
  }
}
