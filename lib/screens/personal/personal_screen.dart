import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/friend/friend_bloc.dart';
import '../../blocs/friend/friend_event.dart';
import '../../blocs/friend/friend_state.dart';
import '../../blocs/personal_info/personal_info_bloc.dart';
import '../../blocs/personal_info/personal_info_event.dart';
import '../../blocs/personal_info/personal_info_state.dart';
import '../../blocs/personal_post/personal_post_bloc.dart';
import '../../blocs/personal_post/personal_post_event.dart';
import '../../blocs/personal_post/personal_post_state.dart';

import '../../models/models.dart' hide Friend;
import './widgets/personal_widgets.dart';
import './sub_screens/personal_subscreens.dart';
import '../newsfeed/widgets/create_post_container.dart';
import '../newsfeed/widgets/post_container.dart';

class PersonalScreen extends StatefulWidget {
  final String? accountId;

  PersonalScreen({this.accountId});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  final _scrollController = ScrollController();

  late final AuthUser authUser;
  late final String? accountId;
  late final String userId; // dùng chung cho cả mình và người khác
  late final bool isMe;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    authUser = BlocProvider.of<AuthBloc>(context).state.authUser;
    accountId = widget.accountId;
    userId = accountId ?? authUser.id;
    isMe = accountId != null ? false : true;
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // if(currentScroll >= (maxScroll * 0.99)) print("POST OBSERVER: Bottom");
    return currentScroll >= (maxScroll * 0.95);
  }

  void _onScroll() {
    if (_isBottom) {
      context
          .read<PersonalPostBloc>()
          .add(PersonalPostFetched(accountId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("#!#0PersonalScreen: Rebuild");
    context.read<PersonalPostBloc>().add(PersonalPostReload(accountId: userId));
    context
        .read<PersonalPostBloc>()
        .add(PersonalPostFetched(accountId: userId));
    if (isMe) {
      print("#!#1Bắt đầu gọi bất đồng bộ");
      context.read<PersonalInfoBloc>().add(PersonalInfoFetched());
      print("#!#2Chưa thực hiện xong PersonalInfoFetched() mà gọi tiếp FriendFetched()");
      context.read<FriendBloc>().add(FriendsFetched());
    } else {
      context.read<PersonalInfoBloc>().add(PersonalInfoOfAnotherUserFetched(id: accountId.toString()));
      context.read<FriendBloc>().add(FriendsOfAnotherUserFetched(id: accountId.toString()));
    }
    print("#!#3Bắt đầu render UI");
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (context) {
              return isMe
                  ? Icon(Icons.menu, color: Colors.black, size: 30)
                  : IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back_ios, color: Colors.black));
            },
          ),
          title: UserNameHeader(),
          centerTitle: true),
      body: RefreshIndicator(
        color: Colors.blue,
        backgroundColor: Colors.white,
        onRefresh: () async {
          context
              .read<PersonalPostBloc>()
              .add(PersonalPostReload(accountId: userId));
          context
              .read<PersonalPostBloc>()
              .add(PersonalPostFetched(accountId: userId));
          return Future<void>.delayed(const Duration(seconds: 2));
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 250.0,
                    color: Colors.white,
                  ),
                  CoverImage(),
                  Positioned(top: 160, left: 360, child: CameraButton()),
                  Positioned(top: 80.0, left: 20.0, child: Avatar()),
                  Positioned(top: 200, left: 135, child: CameraButton())
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserName(),
                    Description(),
                    const SizedBox(height: 15.0),
                    if (isMe) GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileSetScreen()));
                      },
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 45.0,
                            color: Colors.grey[300],
                            child: const Text(
                              "Cài đặt trang cá nhân",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            )),
                      ),
                    ),
                    if (!isMe) Row(
                      children: [
                        FilledButton.tonalIcon(
                            onPressed: () {},
                            icon: Icon(Icons.person_2),
                            label: Text("Bạn bè")
                        ),
                        SizedBox(width: 8),
                        FilledButton.tonalIcon(
                            onPressed: () {},
                            icon: Icon(Icons.send),
                            label: Text("Nhắn tin")
                        )
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    const Divider(height: 10.0, thickness: 2),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(Icons.cases_sharp),
                        const SizedBox(width: 10.0),
                        LocationText()
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Divider(height: 10.0, thickness: 2),
                    const SizedBox(height: 10.0),
                    Row(
                      children: const [
                        Expanded(
                            child: Text(
                          "Bạn bè",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        )),
                        Text("Xem thêm>>"),
                      ],
                    ),
                    NumberOfFriend(),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Container(
                        height: 150.0,
                        child: ListFriendCompact()
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 13),
                child: isMe ? Text(
                  "Bài viết của bạn", style: Theme.of(context).textTheme.titleLarge,
                ) : Text("Bài viết", style: Theme.of(context).textTheme.titleLarge)
              ),
            ),
            if(isMe) SliverToBoxAdapter(
                child: CreatePostContainer()
            ),
            PersonalPostList()
          ],
          controller: _scrollController,
        ),
      ),
    );
  }
}

class UserNameHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
      final userInfo = state.userInfo;
      return Text(userInfo.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.0));
    });
  }
}

class UserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
      final userInfo = state.userInfo;
      return Text(userInfo.name,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold));
    });
  }
}

class Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return Text(userInfo.description,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic));
        });
  }
}


class Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
      final userInfo = state.userInfo;
      return CircleAvatar(
        radius: 85.0,
        backgroundColor: Colors.white,
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
                context: context, builder: (context) => AvatarBottomSheet());
          },
          child: CircleAvatar(
            radius: 80.0,
            backgroundImage: CachedNetworkImageProvider(userInfo.avatar!="" ? userInfo.avatar : "http://dummyimage.com/100x100.png/ff4444/ffffff"),
          ),
        ),
      );
    });
  }
}

class CoverImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
      final userInfo = state.userInfo;
      return GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context, builder: (context) => CoverBottomSheet());
        },
        child: Container(
          width: double.infinity,
          height: 210.0,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: CachedNetworkImageProvider(userInfo.coverImage!="" ? userInfo.coverImage : "http://dummyimage.com/100x100.png/ff4444/ffffff"),
            fit: BoxFit.cover,
          )),
        ),
      );
    });
  }
}

class LocationText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
      final userInfo = state.userInfo;
      var location = "${userInfo.city}, ${userInfo.country}";
      return RichText(
          text: TextSpan(children: [
        const TextSpan(
            text: "Sống và làm việc tại ",
            style: TextStyle(fontSize: 16.0, color: Colors.black)),
        TextSpan(
            text: location,
            style: const TextStyle(
                fontSize: 17.0,
                color: Colors.black,
                fontWeight: FontWeight.bold))
      ]));
    });
  }
}

class NumberOfFriend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendBloc, FriendState>(
        builder: (context, state) {
          final friendList = state.friendList;
          return Text("${friendList.friends.length.toString()} người bạn",
              style: TextStyle(fontSize: 17.0, color: Colors.grey[700]));
        }
    );
  }
}

class ListFriendCompact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendBloc, FriendState>(builder: (context, state) {
      final friendList = state.friendList;
      return GridView.builder(
        itemCount: 3,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.5)),
        itemBuilder: (context, index) {
          return index >= friendList.friends.length
              ? SizedBox()
              : GridTile(
                  child: Friend(
                    friendName: friendList.friends[index].name,
                    imageUrl: friendList.friends[index].avatar,
                  ),
                );
        },
      );
    });
  }
}

class PersonalPostList extends StatefulWidget {
  const PersonalPostList({
    Key? key,
  }) : super(key: key);

  @override
  State<PersonalPostList> createState() => _PersonalPostListState();
}

class _PersonalPostListState extends State<PersonalPostList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalPostBloc, PersonalPostState>(
        builder: (context, state) {
      // switch case hết giá trị thì BlocBuilder sẽ tự hiểu không bao giờ rơi vào trường hợp null ---> Siêu ghê
      switch (state.status) {
        case PersonalPostStatus.initial:
          return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        case PersonalPostStatus.loading:
          return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        case PersonalPostStatus.failure:
          return const SliverToBoxAdapter(
              child: Center(child: Text('Failed to fetch posts')));
        case PersonalPostStatus.success:
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return index >= state.postList.posts.length
                ? const CircularProgressIndicator()
                : PostContainer(post: state.postList.posts[index] as Post);
          }, childCount: state.postList.posts.length));
        // return const Center(child: Text('Successed to fetch posts'));
      }
    });
  }
}
