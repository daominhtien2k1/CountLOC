import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/friend/friend_bloc.dart';
import '../../blocs/friend/friend_event.dart';
import '../../blocs/friend/friend_state.dart';

import 'widgets/friend_widgets.dart';
import '../../routes.dart';
import '../../models/models.dart';

class FriendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<FriendBloc>(context).add(FriendsFetched());
    return FriendScreenContent();
  }
}

class FriendScreenContent extends StatefulWidget {
  const FriendScreenContent({
    Key? key,
  }) : super(key: key);

  @override
  State<FriendScreenContent> createState() => _FriendScreenContent();
}

class _FriendScreenContent extends State<FriendScreenContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu)
            ),
            title: Text("Bạn bè"),
            actions: [
              IconButton(onPressed: (){}, icon: Icon(Icons.search)),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 2, 0),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.unknown_people_screen);
                          },
                          child: Text('Gợi ý'),
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.request_friend_screen);
                          },
                          child: Text('Lời mời kết bạn'),
                        )),
                  ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Row(
                      children: [
                        Text("Danh sách bạn bè", style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ))),
          ),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              sliver: FriendList()
          ),
        ],
      ),
    );
  }
}

class FriendList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendBloc, FriendState>(
        builder: (context, state) {
          switch (state.status) {
            case FriendStatus.initial:
              return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
            case FriendStatus.loading:
              return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
            case FriendStatus.failure:
              return SliverToBoxAdapter(child: Text("Failed"));
            case FriendStatus.success: {
              final List<Friend> friends = state.friendList.friends;
              final count = state.friendList.count;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return FriendContainer(friend: friends[index]);
                  },
                  childCount: count
                )
              );
            }
          }
      }
    );
  }
}

