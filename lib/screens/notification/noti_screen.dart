import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import './widgets/noti_widgets.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Thông báo ",
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: () {},
                          icon: const Icon(MdiIcons.magnify))
                    ],
                  )),
              Divider(),
              NotificationContainer(name: "Tiền Minh Đáo",
                  avtUrl: "https://pbs.twimg.com/media/EYOq_ZbXsAAYbfN.jpg",
                  action: "like",
                  read: true,
                  timeAgo: "4 phút"),
              NotificationContainer(name: "Luminescence",
                  avtUrl: "https://pbs.twimg.com/media/Fow28YxaAAAqYWP.jpg",
                  action: "comment",
                  read: false,
                  timeAgo: "15 phút"),
              NotificationContainer(name: "Lily",
                  avtUrl: "https://pbs.twimg.com/media/FmbD8mxWQAIFb2q.jpg",
                  action: "like",
                  read: true,
                  timeAgo: "2 giờ"),
              NotificationContainer(name: "Nội thất ABC",
                  avtUrl: "https://pbs.twimg.com/media/Fo4GopbXwAEqRaK.jpg",
                  action: "comment",
                  read: true,
                  timeAgo: "2 giờ"),
              NotificationContainer(name: "Nội thất ABC",
                  avtUrl: "https://pbs.twimg.com/media/Fo4GopbXwAEqRaK.jpg",
                  action: "like",
                  read: true,
                  timeAgo: "2 giờ"),
              NotificationContainer(name: "Người Nổ",
                  avtUrl: "https://pbs.twimg.com/media/FolACqSaYAAOYc6.jpg",
                  action: "comment",
                  read: true,
                  timeAgo: "10 giờ"),
              NotificationContainer(name: "Chimera",
                  avtUrl: "https://pbs.twimg.com/media/Fo3zqP6WIAMCdh4.jpg",
                  action: "like",
                  read: true,
                  timeAgo: "11 giờ"),
              NotificationContainer(name: "Nội thất ABC",
                  avtUrl: "https://pbs.twimg.com/media/Fo4GopbXwAEqRaK.jpg",
                  action: "like",
                  read: true,
                  timeAgo: "11 giờ"),
              Divider(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,5),
                  child: Text("Không còn thông báo mới nào",
                      style: TextStyle(
                          fontSize: 16, color: Colors.grey)),
                ),
              ),

            ]),
          ),
        )
    );
  }

}
