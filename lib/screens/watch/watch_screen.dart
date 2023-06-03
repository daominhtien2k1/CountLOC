import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/models.dart';
import '../../blocs/list_video/list_video_bloc.dart';
import '../../blocs/list_video/list_video_event.dart';
import '../../blocs/list_video/list_video_state.dart';

class WatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ListVideoBloc>(context).add(ListVideoFetched());
    return WatchTab();
  }
}

class WatchTab extends StatefulWidget {
  @override
  _WatchTabState createState() => _WatchTabState();
}

class _WatchTabState extends State<WatchTab> {
  Color backgroundColor = Colors.white;

  void initState(){
    context.read<ListVideoBloc>().add(ListVideoFetched());
    super.initState();
  }
  changeBackgroundColor() {
    setState(() {
      backgroundColor = Colors.black;
    });
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          context.read<ListVideoBloc>().add(ListVideoReload());
          context.read<ListVideoBloc>().add(ListVideoFetched());
          return Future<void>.delayed(const Duration(seconds: 2));
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.white, // Navigation bar
                statusBarColor: Colors.lightBlue, // Status bar
              ),
              floating: true,
              automaticallyImplyLeading: false,
              // pinned: true,
              title: Text(
                  'Watch',
                  style: TextStyle(color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.bold)
              ),
              actions: [
                Container(
                  height: 42.0,
                  width: 42.0,
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,

                  ),
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(Icons.person),
                    iconSize: 28,
                    color: Colors.black,
                    onPressed: () {},
                  ),
                ),
                Container(
                  height: 42.0,
                  width: 42.0,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle
                  ),
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(Icons.search),
                    iconSize: 30,
                    color: Colors.black,
                    onPressed: () {},
                  ),
                )
              ],
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(47.0),
                child: Transform.translate(
                    offset: const Offset(6, 0),
                    child: Container(
                      height: 50,
                      color: Colors.white,
                      child: Material(
                        color: Colors.transparent,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index){
                              return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  child: WatchFilterSection(changeBackgroundColor: changeBackgroundColor)
                              );
                            }
                        ),
                      ),
                    )

                ),
              ),
            ),
            VideoList()
          ],
        )
    );

  }
}

class VideoList extends StatefulWidget {

  const VideoList({
    Key? key,
  }) : super(key: key);

  @override
  State<VideoList> createState() => _VideoListState();
}
class _VideoListState extends State<VideoList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListVideoBloc,ListVideoState>(
        builder:  (context, state) {
          // switch case hết giá trị thì BlocBuilder sẽ tự hiểu không bao giờ rơi vào trường hợp null ---> Siêu ghê
          switch (state.status) {
            case ListVideoStatus.initial:
              return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
            case ListVideoStatus.loading:
              return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
            case ListVideoStatus.failure:
              return const SliverToBoxAdapter(child: Center(child: Text('Failed to fetch posts')));
            case ListVideoStatus.success:
              return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index){
                    return VideoPost(videoElement: state.videoList.videos[index] as VideoElement);
                  },
                      childCount: state.videoList.videos.length)
              );

          }
        }
    );
  }

}

class VideoPost extends StatelessWidget {
  final VideoElement videoElement;
  const VideoPost({Key? key, required this.videoElement}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // tính timeAgo
    DateTime dt1 = DateTime.now();
    DateTime dt2 = DateTime.parse(videoElement.updatedAt);
    final Duration diff = dt1.difference(dt2);
    String timeAgo;
    if(videoElement.isAdsCampaign) {
      timeAgo = "Được tài trợ";
    } else timeAgo = diff.inDays == 0 ? "${diff.inHours}h" : "${diff.inDays}d";

    void handleLikePost() {
      // print("#PostContainer: Like post: ${post.id}");
      BlocProvider.of<ListVideoBloc>(context).add(VideoPostLike(video: videoElement));
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PostHeader(avtUrl: "https://i.pinimg.com/564x/5b/ac/75/5bac7554c5c6ce538a7dcf00b7de88c4.jpg", name: "Facebook", timeAgo: timeAgo),
                  const SizedBox(height: 4),
                  Text(videoElement.described)
                ]
            ),
          ),
          VideoContainer(url: videoElement.video.url),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _PostStats(likes: videoElement.likes, isLiked: videoElement.isLiked, onLikePost: handleLikePost),
          )
        ],
      ),
    );
  }
}



class VideoContainer extends StatefulWidget {
  final String url;
  const VideoContainer({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoContainer> createState() => _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer> {
  late YoutubePlayerController _controller;

  late bool isMute = true;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: (YoutubePlayer.convertUrlToId(widget.url)!),
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
        controller: _controller,
      ),
      builder: (context, player){
        return Stack(
          // fit: StackFit.expand,
          children:<Widget>[
            Container(
              // height: 236,
              // width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: player
              ),
            ),
            // player,
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.airplay_sharp),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
            Positioned(
              bottom: 15,
              right: 10,
              child:
              // Icon( Icons.volume_up_rounded),
              CircleAvatar(
                radius: 17,
                backgroundColor: Colors.black,
                child: IconButton(
                  icon: Icon(
                    isMute
                      ? Icons.volume_off_rounded
                      : Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 20,),
                  onPressed: () {
                    setState(() {
                      isMute = !isMute;
                      if(isMute) _controller.setVolume(0);
                      else _controller.setVolume(100);
                    });

                  },

                ),
              ),
            )
          ],
        );
        });
  }
}


class WatchFilterSection extends StatelessWidget {
  final Function changeBackgroundColor;
  WatchFilterSection({Key? key, required this.changeBackgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          children: [
            WatchSection(title: 'Trực tiếp',icons: Icons.video_camera_front, changeBackgroundColor: changeBackgroundColor),
            WatchSection(title: 'Ẩm thực',icons: Icons.umbrella, changeBackgroundColor: changeBackgroundColor),
            WatchSection(title: 'Chơi game',icons: Icons.gas_meter, changeBackgroundColor: changeBackgroundColor),
            WatchSection(title: 'Đang theo dõi',icons: Icons.gas_meter, changeBackgroundColor: changeBackgroundColor),
            WatchSection(title: 'Reels',icons: Icons.gas_meter, changeBackgroundColor: changeBackgroundColor),
          ],
        ),
    );
  }
}

class WatchSection extends StatelessWidget {
  final String title;
  final IconData icons;
  final Function changeBackgroundColor;
  WatchSection({Key? key, required this.title, required this.icons, required this.changeBackgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton.icon(
        label: Text(title),
        icon: Icon(icons),
        onPressed: () => {
          changeBackgroundColor()
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
          ),
        ),
      ),
    );

  }
}

class _PostHeader extends StatelessWidget {
  final String avtUrl;
  final String name;
  final String timeAgo;
  const _PostHeader({Key? key, required this.avtUrl, required this.name, required this.timeAgo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: CircleAvatar(
              radius: 22.0,
              backgroundImage: CachedNetworkImageProvider(avtUrl)
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Row(
                children: [
                  Text('$timeAgo \u00B7 ', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  Icon(Icons.public,color: Colors.grey[600], size: 12)
                ],
              )
            ],
          ),
        ),
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: const Icon(Icons.more_horiz),
          onPressed: (){},
        )
      ],
    );
  }
}

class _PostStats extends StatelessWidget {
  final int likes;
  final bool isLiked;
  final Function() onLikePost;
  const _PostStats({Key? key, required this.likes, required this.isLiked, required this.onLikePost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle
              ),
              child: const Icon(
                Icons.thumb_up,
                size: 10,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                '${likes}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: _PostButton(
                icon: isLiked? Icon(Icons.thumb_up, color: Colors.blue, size: 20) : Icon(Icons.thumb_up_outlined, color: Colors.grey[600], size: 20),
                label: 'Thích',
                onTap: (){
                  onLikePost();
                },
              )
            ),
            Expanded(
              child: _PostButton(
                icon: Icon(MdiIcons.commentOutline, color: Colors.grey[600], size: 20),
                label: 'Bình luận',
                onTap: (){},
              ),
            ),
            Expanded(
              child: _PostButton(
                icon: Icon(MdiIcons.shareOutline, color: Colors.grey[600], size: 25),
                label: 'Chia sẻ',
                onTap: (){},
              ),
            )
          ],
        )
      ],
    );
  }
}

class _PostButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final VoidCallback onTap;
  const _PostButton({Key? key, required this.icon, required this.label, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 4),
              Text(label)
            ],
          ),
        ),
      ),
    );
  }
}
