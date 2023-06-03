import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../constants/assets/placeholder.dart';
import '../../../models/models.dart';
import '../../../routes.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/personal_post/personal_post_bloc.dart';
import '../../../blocs/personal_post/personal_post_event.dart';
import '../../../blocs/post/post_bloc.dart';
import '../../../blocs/post/post_event.dart';

class PostContainer extends StatelessWidget {
  final Post post;
  const PostContainer({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("#PostContainer: Rebuild ${post.id}");

    // tính timeAgo
    DateTime dt1 = DateTime.now();
    DateTime dt2 = DateTime.parse(post.updatedAt);
    final Duration diff = dt1.difference(dt2);
    final String timeAgo = diff.inDays == 0 ? "${diff.inHours}h" : "${diff.inDays}d";

    Future<void> handleLikePost() async {
      // print("#PostContainer: Like post: ${post.id}");
      // Bị vấn đề là dùng chung PostContainer và khi state của 1 trong 2 cái chưa load hết mà update thì sẽ khả năng lỗi mảng cao
      // Đã sửa bằng cách fix if(indexOfMustUpdatePost == -1) return; ---> nhưng chỉ update được 1 trong 2 cái, 1 cái còn lại luôn báo lỗi không thấy mảng -1 dù cả 2 đã load hết state ---> Tạm chấp nhận được
      BlocProvider.of<PostBloc>(context).add(PostLike(post: post)); // 21:32:03:066 mất 507mss
      await Future.delayed(const Duration(milliseconds: 500)); // fix lỗi tăng 2 like do gửi bất đồng bộ 21:40:46:096 OK -- trừ đi (> 500ms??? là) 21:40:46.601 Fail
      BlocProvider.of<PersonalPostBloc>(context).add(PersonalPostLike(post: post)); // 21:32:03:201 mất 492ms
    }

    void handleOtherPostEvent(Map event) {
      if(event['action'] == 'navigateToDetailPost') {
        // print(post.id);
        Navigator.pushNamed(context, Routes.post_detail_screen, arguments: post.id);
      } else if (event['action'] == 'navigateToPersonalScreen') {
        Navigator.pushNamed(context, Routes.personal_screen, arguments: post.author.id);
      }
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
                 _PostHeader(avtUrl: post.author.avatar, name: post.author.name, timeAgo: timeAgo, status: post.status, classification: post.classification, onHandleOtherPostEvent: (event) => handleOtherPostEvent(event), extras: {'postId': post.id, 'authorId': post.author.id}),
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
              child: PostVideoContainer(url: post.video?.url ?? VideoPlaceHolder.videoPlaceHolderOnline),
          ) : const SizedBox.shrink(),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _PostStats(likes: post.likes, comments: post.comments, shares: 0, isLiked: post.isLiked, onLikePost: handleLikePost, onHandleOtherPostEvent: (event) => handleOtherPostEvent(event)),
          )
        ],
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final String avtUrl;
  final String name;
  final String timeAgo;
  final String? status;
  final String classification;
  final Function(Map event)? onHandleOtherPostEvent;
  final Map? extras;
  const _PostHeader({Key? key, required this.avtUrl, required this.name, required this.timeAgo, this.status, required this.classification, this.onHandleOtherPostEvent, this.extras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String classificationGroup;
    switch (classification) {
      case "General":
        classificationGroup = "Chung";
        break;
      case "Question":
        classificationGroup = "Góc hỏi đáp";
        break;
      case "Share experience":
        classificationGroup = "Chia sẻ kinh nghiệm";
        break;
      default:
        classificationGroup = "Chung";
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            onHandleOtherPostEvent?.call({'action': 'navigateToPersonalScreen'});
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: CircleAvatar(
              radius: 22.0,
              backgroundImage: CachedNetworkImageProvider(avtUrl)
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  onHandleOtherPostEvent?.call({'action': 'navigateToPersonalScreen'});
                },
                child: RichText(
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
              ),
              Row(
                children: [
                  Text('$timeAgo \u00B7 ', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(text: 'đăng trên ',  style: TextStyle(color: Colors.black, fontSize: 12)),
                          TextSpan(text: '$classificationGroup', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12)),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis
                  ),
                ],
              )
            ],
          ),
        ),
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: const Icon(Icons.more_horiz),
          onPressed: (){
            showModalBottomSheet(
                context: context,
                builder: (context) => OptionContainerBottomSheet(postId: extras?["postId"], authorId: extras?["authorId"])
            );
          },
        )
      ],
    );
  }
}

class _PostStats extends StatelessWidget {
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final Function() onLikePost;
  final Function(Map event)? onHandleOtherPostEvent;

  const _PostStats({Key? key, required this.likes, required this.comments, required this.shares, required this.isLiked, required this.onLikePost, this.onHandleOtherPostEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            onHandleOtherPostEvent?.call({'action': 'navigateToDetailPost'});
          },
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle
                ),
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
              ),
            ),
            Expanded(
              child: _PostButton(
                icon: Icon(MdiIcons.commentOutline, color: Colors.grey[600], size: 20),
                label: 'Bình luận',
                onTap: (){
                  onHandleOtherPostEvent?.call({'action': 'navigateToDetailPost'});
                },
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

class PostVideoContainer extends StatefulWidget {
  final String url;
  PostVideoContainer({Key? key, required this.url}) : super(key: key);

  @override
  State<PostVideoContainer> createState() => _PostVideoContainerState();
}

class _PostVideoContainerState extends State<PostVideoContainer> {
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

class OptionContainerBottomSheet extends StatelessWidget {
  final String postId;
  final String authorId;
  const OptionContainerBottomSheet({Key? key, required this.postId, required this.authorId}) : super(key: key);

  void rejectConfirmation(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Xác nhân xóa bài viết?'),
            actions: [
              OutlinedButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent)
                ),
                onPressed: () {
                  BlocProvider.of<PostBloc>(context).add(PostDelete(postId: postId));
                  Navigator.pop(context);
                },
                child: Text('Xác nhận',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              OutlinedButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade200)
                ),
                onPressed: () {
                  //TODO: Xử lý sau
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final authUser = BlocProvider.of<AuthBloc>(context).state.authUser;
    final userId = authUser.id;
    final bool isMe = (userId == authorId);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      // height: 210.0,
      constraints: BoxConstraints(
          minHeight: 100,
          minWidth: double.maxFinite,
          maxHeight: 150),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.grey[300],
            ),
            alignment: Alignment.center,
            width: 70.0,
            height: 5.0,
          ),
          const SizedBox(height: 8.0),
          if(isMe)
            BottomSheetOptionButton(
              icon: Icons.edit,
              buttonText: "Chỉnh sửa bài viết",
              onPressed: () {

              }
            ),
          if(isMe)
            BottomSheetOptionButton(
                icon: Icons.delete_forever,
                buttonText: "Xóa bài viết",
                onPressed: () {
                  Navigator.pop(context);
                  rejectConfirmation(context);
                }
            ),
          if(!isMe)
            BottomSheetOptionButton(
              icon: Icons.info,
              buttonText: "Báo cáo bài viết",
              onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Container(
                        height: MediaQuery.of(context).copyWith().size.height * 0.75,
                        child: ReportPostBottomSheet(postId: postId)
                    )
                );
              }
          )
        ],
      ),
    );
  }
}

class BottomSheetOptionButton extends StatelessWidget {
  final IconData icon;
  final String buttonText;
  final void Function()? onPressed;

  const BottomSheetOptionButton({Key? key,
    required this.icon,
    required this.buttonText,
    required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 32),
            SizedBox(width: 15.0),
            Text(buttonText,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}


class ReportPostBottomSheet extends StatefulWidget {
  final String postId;
  const ReportPostBottomSheet({Key? key, required this.postId}) : super(key: key);

  @override
  State<ReportPostBottomSheet> createState() => _ReportPostBottomSheetState();
}

class _ReportPostBottomSheetState extends State<ReportPostBottomSheet> {
  String subject = 'Chưa có';
  String details = 'Chưa có';

  @override
  Widget build(BuildContext context) {
    const subjectArray = ['Ảnh khỏa thân', 'Bạo lực', 'Quấy rồi', 'Tự tử hoặc tự gây thương tích', 'Thông tin sai sự thật', 'Spam', 'Bán hàng trái phép', 'Ngôn từ gây thù ghét', 'Khủng bố'];

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Center(
              child: Text("Báo cáo bài viết", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            )
          ),
          Divider(height: 10, color: Colors.blueGrey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("Hãy chọn vấn đề", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 10, 8),
            child: Text("Nếu bạn nhận thấy bài viết có vấn đề, đừng chần chừ mà hãy báo cáo ngay cho đội ngữ Facebook của chúng tôi xem xét", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
          ),
          Container(
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               ReportPostItem(subject: subjectArray[0], onTap: () {
                 setState(() {
                   this.subject = subjectArray[0];
                   this.details = subjectArray[0];
                 });
               }),
                Divider(height: 8, color: Colors.blueGrey),
                ReportPostItem(subject: subjectArray[1], onTap: () {
                  setState(() {
                    this.subject = subjectArray[1];
                    this.details = subjectArray[1];
                  });
                }),
                Divider(height: 8, color: Colors.blueGrey),
                ReportPostItem(subject: subjectArray[2], onTap: () {
                  setState(() {
                    this.subject = subjectArray[2];
                    this.details = subjectArray[2];
                  });
                }),
                Divider(height: 8, color: Colors.blueGrey),
                ReportPostItem(subject: subjectArray[3], onTap: () {
                  setState(() {
                    this.subject = subjectArray[3];
                    this.details = subjectArray[3];
                  });
                }),
                Divider(height: 8, color: Colors.blueGrey),
                ReportPostItem(subject: subjectArray[4], onTap: () {
                  setState(() {
                    this.subject = subjectArray[4];
                    this.details = subjectArray[4];
                  });
                }),
                Divider(height: 8, color: Colors.blueGrey),
                ReportPostItem(subject: subjectArray[5], onTap: () {
                  setState(() {
                    this.subject = subjectArray[5];
                    this.details = subjectArray[5];
                  });
                }),
                Center(
                  child: Text("Vấn đề đang chọn: $subject", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  BlocProvider.of<PostBloc>(context).add(PostReport(postId: widget.postId, subject: subject, details: details));
                  Navigator.pop(context);
                },
                child: const Text('Gửi'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReportPostItem extends StatelessWidget {
  final String subject;
  final Function() onTap;
  const ReportPostItem({Key? key, required this.subject, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 10, 8),
      child: InkWell(
          onTap: onTap,
          child: Text(subject, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20))),
    );
  }
}
