import 'package:flutter/material.dart';

import 'notification_settings_detail_screen.dart';

class NotificationSettingsScreen extends StatelessWidget {
  static final Map<String, IconData> _icons = {
    'comment': Icons.comment,
    'tag': Icons.tag,
    'notifications_active': Icons.notifications_active,
    'call_to_action': Icons.call_to_action,
    'people_outline': Icons.people_outline,
    'person_add_alt_1_rounded': Icons.person_add_alt_1_rounded,
    'groups': Icons.groups,
    'cake_outlined': Icons.cake_outlined,
    'video': Icons.ondemand_video,
    'event': Icons.date_range,
    'page': Icons.flag,
    'marketplace': Icons.storefront,
    'campaign': Icons.campaign,
    'person': Icons.switch_account,
    'other': Icons.more_horiz
  };

  static final Map<String, String> _title = {
    'comment': 'Bình luật',
    'tag': 'Thẻ',
    'notifications_active': 'Lời nhắc',
    'call_to_action': 'Hoạt động khác về bạn',
    'people_outline': 'Cập nhật từ bạn bè',
    'person_add_alt_1_rounded': 'Lời mời kết bạn',
    'groups': 'Nhóm',
    'cake_outlined': 'Sinh nhật',
    'video': 'video',
    'event': 'Sự kiện',
    'page': 'Trang bạn theo dõi',
    'marketplace': 'Marketplace',
    'campaign': 'Chiến dịch gây quỹ và tình huống khẩn cấp',
    'other': 'Thông báo khác',
    'person': 'Những người bạn có thể biết'
  };

  ListTile tileCus(String str, BuildContext context) {
    return ListTile(
      title: Text(_title[str]!),
      subtitle: Text("Thông báo đẩy, email, SMS"),
      leading: Icon(_icons[str]),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationSettingsDetailScreen(_title[str]!)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: const Text('Cài đặt thông báo',
              style: TextStyle(color: Colors.black)),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        ),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: [
            tileCus('comment', context),
            tileCus('tag', context),
            tileCus('notifications_active', context),
            tileCus('call_to_action', context),
            tileCus('people_outline', context),
            tileCus('person_add_alt_1_rounded', context),
            tileCus('groups', context),
            tileCus('cake_outlined', context),
            tileCus('video', context),
            tileCus('event', context),
            tileCus('page', context),
            tileCus('marketplace', context),
            tileCus('campaign', context),
            tileCus('person', context),
            tileCus('other', context),
          ],
        ));
  }
}
