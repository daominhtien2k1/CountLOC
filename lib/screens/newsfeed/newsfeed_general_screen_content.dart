import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/post/post_bloc.dart';
import '../../blocs/post/post_event.dart';
import '../../blocs/post/post_state.dart';

import '../../models/models.dart';
import 'widgets/newsfeed_widgets.dart';

class NewsfeedGeneralScreenContent extends StatefulWidget {
  const NewsfeedGeneralScreenContent({
    Key? key,
  }) : super(key: key);

  @override
  State<NewsfeedGeneralScreenContent> createState() => _NewsfeedGeneralScreenContentState();
}

class _NewsfeedGeneralScreenContentState extends State<NewsfeedGeneralScreenContent> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostBloc>(context).add(PostsFetched());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom){
      context.read<PostBloc>().add(PostsFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // if(currentScroll >= (maxScroll * 0.99)) print("POST OBSERVER: Bottom");
    return currentScroll >= (maxScroll * 0.95);
  }

  @override
  Widget build(BuildContext context) {
    print("#HomeScreen: Rebuild");
    return RefreshIndicator(
      color: Colors.blue,
      backgroundColor: Colors.white,
      onRefresh: () async {
        context.read<PostBloc>().add(PostsReload());
        context.read<PostBloc>().add(PostsFetched());
        return Future<void>.delayed(const Duration(seconds: 2));
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: CreatePostContainer()
          ),
          // SliverPadding(
          //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          //   sliver: SliverToBoxAdapter(
          //     child: OnlineUsers(onlineUsers: onlineUsers)
          //   ),
          // ),
          // PostList()
          PostList()
        ],
        controller: _scrollController,
      ),
    );
  }
}

class PostList extends StatefulWidget {
  const PostList({
    Key? key,
  }) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          // switch case hết giá trị thì BlocBuilder sẽ tự hiểu không bao giờ rơi vào trường hợp null ---> Siêu ghê
          switch (state.status) {
            case PostStatus.initial:
              return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
            case PostStatus.loading:
              return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
            case PostStatus.failure:
              return const SliverToBoxAdapter(child: Center(child: Text('Failed to fetch posts')));
            case PostStatus.success:
              return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return index >= state.postList.posts.length
                        ? const CircularProgressIndicator()
                        : PostContainer(post: state.postList.posts[index] as Post);
                  },
                      childCount: state.postList.posts.length)
              );
          // return const Center(child: Text('Successed to fetch posts'));
          }
        }
    );
  }
}
