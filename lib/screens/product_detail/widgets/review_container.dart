import 'package:cosmetic_frontend/common/widgets/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../common/widgets/star_list.dart';
import '../../../constants/assets/placeholder.dart';
import '../../../models/models.dart';
import '../../../routes.dart';

import '../../../blocs/auth/auth_bloc.dart';

// Standard and Detail
class ReviewContainer extends StatelessWidget {
  final Review review;
  const ReviewContainer({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String characteristicReviewsText = "";

    review.characteristicReviews?.forEach((element) {
      characteristicReviewsText += " - ${element.characteristic} (${element.point})";
    });
    if(characteristicReviewsText.isNotEmpty) characteristicReviewsText = characteristicReviewsText.substring(3);

    // tính timeAgo
    DateTime dt1 = DateTime.now();
    DateTime dt2 = DateTime.parse(review.updatedAt);
    final Duration diff = dt1.difference(dt2);
    final String timeAgo = diff.inDays == 0 ? "${diff.inHours}h" : "${diff.inDays}d";

    Future<void> handleSetUsefulReview() async {

    }

    void handleOtherReviewEvent(Map event) {
      if(event['action'] == 'navigateToDetailReview') {
        Navigator.pushNamed(context, Routes.review_detail_screen, arguments: review.id);
      } else if (event['action'] == 'navigateToPersonalScreen') {
        Navigator.pushNamed(context, Routes.personal_screen, arguments: review.author.id);
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
                  _ReviewHeader(avtUrl: review.author.avatar, name: review.author.name, timeAgo: timeAgo, onHandleOtherReviewEvent: (event) => handleOtherReviewEvent(event), extras: {'reviewId': review.id, 'authorId': review.author.id}),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        if(review.rating != null) Column(
                          children: [
                            Text("Đánh giá"),
                            StarList(rating: review.rating?.toDouble() ?? 0, color: Colors.orangeAccent),
                          ],
                        ),
                        if(review.rating != null) SizedBox(width: 24),
                        Container(
                          width: review.rating != null ? 250 : 348,
                          child: Text("${review.title}",
                          style: Theme.of(context).textTheme.titleMedium)
                        )
                      ],
                    ),
                  ),
                  if(characteristicReviewsText.isNotEmpty) Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent.shade100,
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: Text(characteristicReviewsText),
                    ),
                  ),
                  const SizedBox(height: 4),
                  review.classification != "Instruction" ?
                    Text("${review.content}")
                      : ExpandableTextWidget(text: "${review.content}", isHtml: true)
                ]
            ),
          ),
          const SizedBox(height: 4),
          review.images != null ?
          Container(
            height: 200,
            child: GridView.count(
              padding: EdgeInsets.all(0),
              crossAxisCount: review.images?.length == 1 ? 1 : 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: review.images!.map((image) {
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
          review.video != null ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: ReviewVideoContainer(url: review.video?.url ?? VideoPlaceHolder.videoPlaceHolderOnline),
          ) : const SizedBox.shrink(),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _ReviewStats(usefuls: review.usefuls, replies: review.replies, isSettedUseful: review.isSettedUseful, onSetUsefulReview: handleSetUsefulReview, onHandleOtherReviewEvent: (event) => handleOtherReviewEvent(event)),
          )
        ],
      ),
    );
  }
}

class _ReviewHeader extends StatelessWidget {
  final String avtUrl;
  final String name;
  final String timeAgo;
  final Function(Map event)? onHandleOtherReviewEvent;
  final Map? extras;
  const _ReviewHeader({Key? key, required this.avtUrl, required this.name, required this.timeAgo, this.onHandleOtherReviewEvent, this.extras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            onHandleOtherReviewEvent?.call({'action': 'navigateToPersonalScreen'});
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
                  onHandleOtherReviewEvent?.call({'action': 'navigateToPersonalScreen'});
                },
                child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(text: '$name ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis
                ),
              ),
              Row(
                children: [
                  Text('$timeAgo \u00B7 ', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
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
                builder: (context) => OptionContainerBottomSheet(reviewId: extras?["reviewId"], authorId: extras?["authorId"])
            );
          },
        )
      ],
    );
  }
}

class _ReviewStats extends StatelessWidget {
  final int usefuls;
  final int replies;
  final bool isSettedUseful;
  final Function() onSetUsefulReview;
  final Function(Map event)? onHandleOtherReviewEvent;

  const _ReviewStats({Key? key, required this.usefuls,  required this.replies, required this.isSettedUseful, required this.onSetUsefulReview, this.onHandleOtherReviewEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            onHandleOtherReviewEvent?.call({'action': 'navigateToDetailReview'});
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
                  '${usefuls} người cảm thấy hữu ích',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Text(
                '${replies} bình luận',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: _ReviewButton(
                icon: isSettedUseful? Icon(Icons.thumb_up, color: Colors.blue, size: 20) : Icon(Icons.thumb_up_outlined, color: Colors.grey[600], size: 20),
                label: 'Hữu ích',
                onTap: (){
                  onSetUsefulReview();
                },
              ),
            ),
            Expanded(
              child: _ReviewButton(
                icon: Icon(MdiIcons.commentOutline, color: Colors.grey[600], size: 20),
                label: 'Bình luận',
                onTap: (){
                  onHandleOtherReviewEvent?.call({'action': 'navigateToDetailReview'});
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final VoidCallback onTap;
  const _ReviewButton({Key? key, required this.icon, required this.label, required this.onTap}) : super(key: key);


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

class ReviewVideoContainer extends StatefulWidget {
  final String url;
  ReviewVideoContainer({Key? key, required this.url}) : super(key: key);

  @override
  State<ReviewVideoContainer> createState() => _ReviewVideoContainerState();
}

class _ReviewVideoContainerState extends State<ReviewVideoContainer> {
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
  final String reviewId;
  final String authorId;
  const OptionContainerBottomSheet({Key? key, required this.reviewId, required this.authorId}) : super(key: key);

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
                  // todo
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
                          child: ReportReviewBottomSheet(reviewId: reviewId)
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

class ReportReviewBottomSheet extends StatefulWidget {
  final String reviewId;
  const ReportReviewBottomSheet({Key? key, required this.reviewId}) : super(key: key);

  @override
  State<ReportReviewBottomSheet> createState() => _ReportReviewBottomSheetState();
}

class _ReportReviewBottomSheetState extends State<ReportReviewBottomSheet> {
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
                ReportReviewItem(subject: subjectArray[0], onTap: () {
                  setState(() {
                    this.subject = subjectArray[0];
                    this.details = subjectArray[0];
                  });
                }),
                Divider(height: 8, color: Colors.blueGrey),
                ReportReviewItem(subject: subjectArray[1], onTap: () {
                  setState(() {
                    this.subject = subjectArray[1];
                    this.details = subjectArray[1];
                  });
                }),
                Divider(height: 8, color: Colors.blueGrey),
                ReportReviewItem(subject: subjectArray[2], onTap: () {
                  setState(() {
                    this.subject = subjectArray[2];
                    this.details = subjectArray[2];
                  });
                }),
                Divider(height: 8, color: Colors.blueGrey),
                ReportReviewItem(subject: subjectArray[3], onTap: () {
                  setState(() {
                    this.subject = subjectArray[3];
                    this.details = subjectArray[3];
                  });
                }),
                Divider(height: 8, color: Colors.blueGrey),
                ReportReviewItem(subject: subjectArray[4], onTap: () {
                  setState(() {
                    this.subject = subjectArray[4];
                    this.details = subjectArray[4];
                  });
                }),
                Divider(height: 8, color: Colors.blueGrey),
                ReportReviewItem(subject: subjectArray[5], onTap: () {
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
                  // todo
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

class ReportReviewItem extends StatelessWidget {
  final String subject;
  final Function() onTap;
  const ReportReviewItem({Key? key, required this.subject, required this.onTap}) : super(key: key);

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
