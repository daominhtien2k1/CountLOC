import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../blocs/post_detail/post_detail_bloc.dart';
import '../../blocs/post_detail/post_detail_event.dart';
import '../../blocs/post_detail/post_detail_state.dart';
import '../../blocs/comment/comment_bloc.dart';
import '../../blocs/comment/comment_event.dart';
import '../../blocs/comment/comment_state.dart';
import '../../constants/assets/placeholder.dart';
import '../../models/models.dart';



class PostDetailScreen extends StatelessWidget {
  final String postId;
  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // null. Hơi lạ
    // final String postId = ModalRoute.of(context)?.settings.arguments as String;
    // print("#PostDetailScreen: " + postId);
    BlocProvider.of<PostDetailBloc>(context).add(PostDetailFetched(postId: postId));
    BlocProvider.of<CommentBloc>(context).add(CommentFetched(postId: postId));
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          // child: SingleChildScrollView(
            child: PostDetailContent(),
          // ),
        )
    );
  }
}

class PostDetailContent extends StatelessWidget {
  const PostDetailContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    void handleLikePost(String id) {
      // print("#PostContainer: Like post: ${post.id}");
      // Bị vấn đề là dùng chung PostContainer và khi state của 1 trong 2 cái chưa load hết mà update thì sẽ khả năng lỗi mảng cao
      // Đã sửa bằng cách fix if(indexOfMustUpdatePost == -1) return; ---> nhưng chỉ update được 1 trong 2 cái, 1 cái còn lại luôn báo lỗi không thấy mảng -1 dù cả 2 đã load hết state ---> Tạm chấp nhận được
      BlocProvider.of<PostDetailBloc>(context).add(PostDetailLike(postId: id));
    }
    return BlocBuilder<PostDetailBloc, PostDetailState>(
        builder: (context, state) {
          switch (state.postDetailStatus) {
            case PostDetailStatus.initial:
              return Center(child: CircularProgressIndicator());
            case PostDetailStatus.loading:
              return Center(child: CircularProgressIndicator());
            case PostDetailStatus.failure:
              return Center(child: Text('Failed to fetch detail post'));
            case PostDetailStatus.success: {
              final post = state.postDetail!;

              DateTime dt1 = DateTime.now();
              DateTime dt2 = DateTime.parse(post.updatedAt);
              final Duration diff = dt1.difference(dt2);
              final String timeAgo = diff.inDays == 0 ? "${diff.inHours}h" : "${diff.inDays}d";

              // void handleLikePost() {
              //   // print("#PostContainer: Like post: ${post.id}");
              //   // Bị vấn đề là dùng chung PostContainer và khi state của 1 trong 2 cái chưa load hết mà update thì sẽ khả năng lỗi mảng cao
              //   // Đã sửa bằng cách fix if(indexOfMustUpdatePost == -1) return; ---> nhưng chỉ update được 1 trong 2 cái, 1 cái còn lại luôn báo lỗi không thấy mảng -1 dù cả 2 đã load hết state ---> Tạm chấp nhận được
              //   BlocProvider.of<PostDetailBloc>(context).add(PostDetailLike(postId: post.id));
              //   // BlocProvider.of<PersonalPostBloc>(context).add(PersonalPostLike(post: post));
              // }

              return Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PostDetailHeader(avtUrl: post.author.avatar, name: post.author.name, timeAgo: timeAgo, status: post.status),
                            const SizedBox(height: 4),
                            Text(post.described)
                          ]
                      ),
                    ),
                    const SizedBox(height: 4),
                    post.images != null ?
                    Container(
                      height: 200,
                      child: GridView.count(
                        padding: EdgeInsets.all(0),
                        crossAxisCount: post.images?.length == 1 ? 1 : 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        children: post.images!.map((image) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: CachedNetworkImage(
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  imageUrl: image.url ?? ImagePlaceHolder.imagePlaceHolderOnline,
                                  errorWidget: (context, url, error) => Icon(Icons.error)
                              )
                          );
                        }).toList(),
                      ),
                    )
                        : const SizedBox.shrink(),
                    post.video != null ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: PostDetailVideoContainer(url: post.video?.url ?? VideoPlaceHolder.videoPlaceHolderOnline),
                    ) : const SizedBox.shrink(),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _PostDetailStats(
                          likes: post.likes,
                          comments: post.comments,
                          shares: 0,
                          isLiked: post.isLiked,
                          onLikePost: () {
                            handleLikePost(post.id);
                          }
                      ),
                    ),
                    // CommentList(),
                    Expanded(child: CommentList()),
                    SendComment(postId: post.id)
                  ],
                ),
              );
            }

          }
        }
    );
  }
}

class _PostDetailHeader extends StatelessWidget {
  final String avtUrl;
  final String name;
  final String timeAgo;
  final String? status;
  const _PostDetailHeader({Key? key, required this.avtUrl, required this.name, required this.timeAgo, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
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
              RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(text: '$name ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                      if(status != null) TextSpan(text: 'hiện đang cảm thấy ',  style: TextStyle(color: Colors.black, fontSize: 16)),
                      if(status != null) TextSpan(text: '$status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis
              ),
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

class _PostDetailStats extends StatelessWidget {
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final Function() onLikePost;

  const _PostDetailStats({Key? key, required this.likes, required this.comments, required this.shares, required this.isLiked, required this.onLikePost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: Colors.blue, shape: BoxShape.circle),
              child: const Icon(
                Icons.thumb_up,
                size: 10,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${likes}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            Text(
              '${comments} bình luận',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${shares} lượt chia sẻ',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            )
          ],
        ),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: _PostDetailButton(
                icon: isLiked? Icon(Icons.thumb_up, color: Colors.blue, size: 20) : Icon(Icons.thumb_up_outlined, color: Colors.grey[600], size: 20),
                label: 'Thích',
                onTap: (){
                  onLikePost();
                },
              ),
            ),
            Expanded(
              child: _PostDetailButton(
                icon: Icon(MdiIcons.commentOutline, color: Colors.grey[600], size: 20),
                label: 'Bình luận',
                onTap: (){},
              ),
            ),
            Expanded(
              child: _PostDetailButton(
                icon: Icon(MdiIcons.shareOutline, color: Colors.grey[600], size: 25),
                label: 'Chia sẻ',
                onTap: (){},
              ),
            )
          ],
        ),
        Material(
          elevation: 0.25,
          color: Colors.grey,
          child: Container(height: 0.25)
        )
      ],
    );
  }
}

class _PostDetailButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final VoidCallback onTap;
  const _PostDetailButton({Key? key, required this.icon, required this.label, required this.onTap}) : super(key: key);

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

class PostDetailVideoContainer extends StatefulWidget {
  final String url;
  PostDetailVideoContainer({Key? key, required this.url}) : super(key: key);

  @override
  State<PostDetailVideoContainer> createState() => _PostDetailVideoContainerState();
}

class _PostDetailVideoContainerState extends State<PostDetailVideoContainer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId: (YoutubePlayer.convertUrlToId(widget.url)!),
        flags: const YoutubePlayerFlags(
          autoPlay: false,
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
    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: YoutubePlayer(controller: _controller)
      ),
    );
  }
}

class CommentList extends StatefulWidget {
  const CommentList({Key? key}) : super(key: key);

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {

  @override
  Widget build(BuildContext context) {
   return BlocBuilder<CommentBloc, CommentState>(
       builder: (context, state) {
         switch (state.commentStatus) {
           case CommentStatus.initial:
             return Center(child: CircularProgressIndicator());
           case CommentStatus.loading:
             return Center(child: CircularProgressIndicator());
           case CommentStatus.failure:
             return Center(child: Text('Failed to fetch comments'));
           case CommentStatus.success: {
             final List<Comment> comments = state.comments ?? <Comment>[];
             return ListView.builder(
               // primary: false,
               // shrinkWrap: true,
               // physics: NeverScrollableScrollPhysics(),
                 padding: const EdgeInsets.all(8),
                 itemCount: comments.length,
                 itemBuilder: (BuildContext context, int index) {
                   final Comment comment = comments[index];
                   return CommentContainer(avtUrl: comment.poster.avatar, name: comment.poster.name, comment: comment.comment, createdAt: comment.createdAt);
                 }
             );
           }
         }
       }
   );
  }

}

class CommentContainer extends StatelessWidget {
  final String avtUrl;
  final String name;
  final String comment;
  final String createdAt;

  CommentContainer({Key? key, required this.avtUrl, required this.name, required this.comment, required this.createdAt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dt1 = DateTime.now();
    DateTime dt2 = DateTime.parse(createdAt);
    final Duration diff = dt1.difference(dt2);
    final String timeAgo = diff.inDays == 0 ? "${diff.inHours} giờ" : "${diff.inDays} ngày";
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold ,fontSize: 18)),
                  SizedBox(height: 4),
                  Text(comment, style: TextStyle(color: Colors.black, overflow: TextOverflow.clip)),
                  SizedBox(height: 4),
                  Text(timeAgo, style: TextStyle(color: Colors.blue, fontStyle: FontStyle.italic, overflow: TextOverflow.clip)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(height: 4, thickness: 1),
                  )
                ],
              )
          )
        ]
      )
    );
  }
}

class SendComment extends StatefulWidget {
  final String postId;
  const SendComment({Key? key, required this.postId}) : super(key: key);

  @override
  State<SendComment> createState() => _SendCommentState();
}

class _SendCommentState extends State<SendComment> {
  late TextEditingController _sendMessageController;
  bool isTextSend = false;
  late FocusNode myFocusNode;
  late bool isMinimize;

  @override
  void initState() {
    super.initState();
    _sendMessageController = new TextEditingController();
    myFocusNode = FocusNode();
    myFocusNode.addListener(() {
      // print("Focus: ${myFocusNode.hasFocus.toString()}");
      if(myFocusNode.hasFocus) {
        setState(() {
          isMinimize = true;
        });
      }else{
        setState(() {
          isMinimize = false;
        });
      }
    });
    isMinimize = myFocusNode.hasFocus;
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _sendMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80,
      // width: double.infinity,
      constraints: BoxConstraints(
          minHeight: 60,
          minWidth: double.maxFinite,
          maxHeight: 160),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: _sendMessageController.text.length <= 20 ? CrossAxisAlignment.center : CrossAxisAlignment.end,
              children: <Widget>[
                isMinimize ?
                GestureDetector(
                  child: Icon(Icons.arrow_forward_ios, size: 35, color: Colors.blue),
                  onTap: () {
                    setState(() {
                      isMinimize = false;
                    });
                  },
                ) :
                Container(
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.add_circle, size: 35,color: Colors.blue),
                      SizedBox(width: 5),
                      Icon(Icons.camera_alt,size: 35,color: Colors.blue),
                      SizedBox(width: 5),
                      Icon(Icons.photo,size: 35,color: Colors.blue)
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 12), //for TextField
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                          Radius.circular(12.0) //                 <--- border radius here
                      ),
                      color: Colors.white,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      cursorColor: Colors.grey,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Viết bình luận của bạn',
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none
                      ),
                      focusNode: myFocusNode,
                      controller: _sendMessageController,
                      onChanged: (text) {
                        if(text.length == 0) {
                          setState(() {
                            isTextSend = false;
                          });
                        }else{
                          setState(() {
                            isTextSend = true;
                            isMinimize = true;
                          });
                        }
                      },
                      onTap: (){
                        setState(() {
                          isMinimize = true;
                        });
                      }
                    ),
                  ),
                ),
                SizedBox(width: 12),
                isTextSend ?
                SizedBox(
                  height: 32.0,
                  width: 32.0,
                  child: IconButton(
                      onPressed: (){
                        final comment = _sendMessageController.text;
                        BlocProvider.of<CommentBloc>(context).add(CommentSet(postId: widget.postId, comment: comment));
                        _sendMessageController.clear();
                        myFocusNode.unfocus();
                      },
                      iconSize: 32,
                      padding: EdgeInsets.all(0),
                      icon: const Icon(Icons.send,color: Colors.blue)
                  ),
                ) :
                const Icon(Icons.sms,size: 32,color: Colors.blue),
              ],
            )
      ),
    );
  }
}
