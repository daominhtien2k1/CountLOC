import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/friend_request_received/friend_request_received_bloc.dart';
import '../../blocs/friend_request_received/friend_request_received_event.dart';
import '../../blocs/friend_request_received/friend_request_received_state.dart';
import '../../models/models.dart';
import 'widgets/friend_widgets.dart';

class RequestFriendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<FriendRequestReceivedBloc>(context).add(ListFriendRequestReceivedFetched());
    return RequestFriendScreenContent();
  }
}

class RequestFriendScreenContent extends StatefulWidget {
  const RequestFriendScreenContent({
    Key? key,
  }) : super(key: key);

  @override
  State<RequestFriendScreenContent> createState() => _RequestFriendScreenContent();
}

class _RequestFriendScreenContent extends State<RequestFriendScreenContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                backgroundColor: Colors.white,
                title: const Text("Lời mời kết bạn"),
                centerTitle: false,
                floating: true,
              ),
              SliverToBoxAdapter(
                  child: Container(
                      color: Colors.white,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Lời mời kết bạn  ",
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold)),
                              NumberOfFriendRequests(),
                            ],
                          )),
                ),
              ),
              SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  sliver: FriendRequestReceivedList()
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberOfFriendRequests extends StatelessWidget {
  const NumberOfFriendRequests({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendRequestReceivedBloc, FriendRequestReceivedState>(
        builder: (context, state) {
      final friendRequestReceivedList = state.friendRequestReceivedList;
      return Text(
          friendRequestReceivedList.listFriendRequestReceived.length.toString(),
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red));
    });
  }
}


class FriendRequestReceivedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendRequestReceivedBloc, FriendRequestReceivedState>(
      builder: (context, state) {
        switch (state.status) {
          case FriendRequestReceivedStatus.initial:
            return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()));
          case FriendRequestReceivedStatus.loading:
            return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()));
          case FriendRequestReceivedStatus.failure:
            return SliverToBoxAdapter(child: Text("Failed"));
          case FriendRequestReceivedStatus.success: {
              final List<FriendRequestReceived> listFriendRequestReceived = state.friendRequestReceivedList.listFriendRequestReceived;
              return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return FriendRequestReceivedContainer(friendRequestReceived: listFriendRequestReceived[index]);
                    },
                    childCount: listFriendRequestReceived.length
                  )
              );
          }
        }
      }
    );
  }
}
