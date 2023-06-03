import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../blocs/friend_request_received/friend_request_received_bloc.dart';
import '../../../blocs/friend_request_received/friend_request_received_event.dart';
import '../../../models/models.dart';

class FriendRequestReceivedContainer extends StatelessWidget {
  final FriendRequestReceived friendRequestReceived;
  const FriendRequestReceivedContainer({Key? key, required this.friendRequestReceived})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dt1 = DateTime.now();
    DateTime dt2 = DateTime.parse(friendRequestReceived.createdAt);
    final Duration diff = dt1.difference(dt2);
    final String timeAgo =
        diff.inDays == 0 ? "${diff.inHours}h" : "${diff.inDays}d";
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
                  CachedNetworkImageProvider(friendRequestReceived.avatar),
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
                        child: Text(friendRequestReceived.name,
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
                          padding: const EdgeInsets.fromLTRB(0, 0, 6, 2),
                          child: FilledButton(
                            onPressed: () {
                              acceptConfirmation(context);
                            },
                            child: Text('Chấp nhận',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ))
                      ),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(6, 0, 0, 2),
                          child: OutlinedButton(
                            onPressed: () {
                              rejectConfirmation(context);
                            },
                            child: Text('Xóa'),
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
      BlocProvider.of<FriendRequestReceivedBloc>(context).add(FriendRequestReceivedAccept(friendRequestReceived: friendRequestReceived));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Chấp nhận lời mời kết bạn?'),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleRequestReceivedFriendAccept();
                },
                child: Text('Xác nhận',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              )
            ],
          );
        });
  }

  void rejectConfirmation(BuildContext context) {
    void handleRequestReceivedFriendDelete() {
      BlocProvider.of<FriendRequestReceivedBloc>(context).add(FriendRequestReceivedDelete(friendRequestReceived: friendRequestReceived));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Xóa lời mời kết bạn?'),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleRequestReceivedFriendDelete();
                },
                child: Text('Xác nhận',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              )
            ],
          );
        });
  }
}
