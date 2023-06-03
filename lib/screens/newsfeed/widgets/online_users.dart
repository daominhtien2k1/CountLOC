import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../models/local/local_models.dart';

class OnlineUsers extends StatelessWidget {
  final List<User> onlineUsers;
  const OnlineUsers({Key? key, required this.onlineUsers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // mong muốn không fix cứng
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: onlineUsers.length,
            itemBuilder: (BuildContext context, int index) {
                if(index == 0) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        alignment: Alignment(0,-1),
                        children: [
                          CircleAvatar(
                            radius: 22.0,
                            backgroundImage: CachedNetworkImageProvider(onlineUsers[0].imageUrl),
                          ),
                          Positioned(
                            right: 1.0,
                            bottom: 0.0,
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: Colors.blue,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                splashRadius: 8,
                                icon: const DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                  ),
                                ),
                                iconSize: 16,
                                color: Colors.white,
                                onPressed: () {
                                  print("hello");
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text('Tin của bạn', style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.black45)),
                    ],
                  );
                }
                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: _ProfileAvatar(avtUrl: onlineUsers[index].imageUrl, name: onlineUsers[index].name, isActive: true));
                }),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String avtUrl;
  final String name;
  final bool isActive;
  const _ProfileAvatar({Key? key, required this.avtUrl, required this.name, this.isActive = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          alignment: Alignment(0,-1),
          children: [
            CircleAvatar(
              radius: 22.0,
              backgroundImage: CachedNetworkImageProvider(avtUrl),
            ),
            Positioned(
              right: 1.0,
              bottom: 1.0,
              child: CircleAvatar(
                radius: 6.0,
                backgroundColor: Colors.greenAccent,
              ),
            ),
          ],
        ),
        Text(name.split(' ')[1], style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.black45)),
      ],
    );
  }
}
