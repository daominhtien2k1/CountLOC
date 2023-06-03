import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../blocs/friend/friend_bloc.dart';
import '../../../blocs/friend/friend_event.dart';
import '../../../models/models.dart';

class FriendContainer extends StatelessWidget {
  final Friend friend;
  const FriendContainer({Key? key, required this.friend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dt1 = DateTime.now();
    DateTime dt2 = DateTime.parse(friend.createdAt);
    final Duration diff = dt1.difference(dt2);
    final String timeAgo =
    diff.inDays == 0 ? "${diff.inHours} giờ" : "${diff.inDays} ngày";
    return Container(
      // color: Colors.white,
      height: 100,
      // child: IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 8, 5),
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
              CachedNetworkImageProvider(friend.avatar),
            ),
          ),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                            flex: 5,
                            child: Text(friend.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18))),
                        Flexible(
                            flex: 2,
                            child: Text(timeAgo,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey)))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 0, 0, 2),
                              child: FilledButton.tonal(
                                onPressed: () {
                                  acceptConfirmation(context);
                                },
                                child: Text('Hủy kết bạn'),
                              ))),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }

  void acceptConfirmation(BuildContext context) {
    void handleRequestReceivedFriendAccept() {
      BlocProvider.of<FriendBloc>(context).add(FriendDelete(friend: friend));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Hủy kết bạn?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleRequestReceivedFriendAccept();
                },
                child: Text('Xác nhận',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )

            ],
          );
        });
  }


}
