import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../blocs/unknown_people/unknown_people_bloc.dart';
import '../../../blocs/unknown_people/unknown_people_event.dart';
import '../../../models/models.dart';

class UnknownPersonContainer extends StatelessWidget {
  final UnknownPerson unknownPerson;
  const UnknownPersonContainer({Key? key, required this.unknownPerson})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              CachedNetworkImageProvider(unknownPerson.avatar),
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
                            child: Text(unknownPerson.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18))),
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
                                  sendRequest(context);
                                },
                                child: Text('Thêm bạn'),
                              ))),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }

  void sendRequest(BuildContext context) {
    void handleSendRequest() {
      BlocProvider.of<UnknownPeopleBloc>(context).add(FriendRequestSend(unknownPerson: unknownPerson));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thêm bạn?'),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleSendRequest();
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
