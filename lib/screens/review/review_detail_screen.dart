import 'package:cosmetic_frontend/blocs/review_detail/review_detail_bloc.dart';
import 'package:cosmetic_frontend/blocs/review_detail/review_detail_event.dart';
import 'package:cosmetic_frontend/blocs/review_detail/review_detail_state.dart';
import 'package:cosmetic_frontend/common/widgets/expandable_text.dart';
import 'package:cosmetic_frontend/constants/assets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../common/widgets/star_list.dart';

class ReviewDetailScreen extends StatelessWidget {
  final String reviewId;
  const ReviewDetailScreen({Key? key, required this.reviewId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ReviewDetailBloc>(context).add(ReviewDetailFetched(reviewId: reviewId));
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết đánh giá"),
      ),
      body: SafeArea(
        // child: SingleChildScrollView(
        child: ReviewDetailContent(),
        // ),
      )
    );
  }
}

// Standard, Detail, Instruction
class ReviewDetailContent extends StatelessWidget {

  const ReviewDetailContent({Key? key}) : super(key: key);

  Future<void> handleSetUsefulReview() async {

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewDetailBloc, ReviewDetailState>(
      builder: (context, state) {
        switch (state.reviewDetailStatus) {
          case ReviewDetailStatus.initial:
            return Center(child: CircularProgressIndicator());
          case ReviewDetailStatus.loading:
            return Center(child: CircularProgressIndicator());
          case ReviewDetailStatus.failure:
            return Center(child: Text("Failed"));
          case ReviewDetailStatus.success: {
            final reviewDetail = state.reviewDetail!;
            String characteristicReviewsText = "";

            reviewDetail.characteristicReviews?.forEach((element) {
              characteristicReviewsText += " - ${element.characteristic} (${element.point})";
            });
            if(characteristicReviewsText.isNotEmpty) characteristicReviewsText = characteristicReviewsText.substring(3);

            // tính timeAgo
            DateTime dt1 = DateTime.now();
            DateTime dt2 = DateTime.parse(reviewDetail.updatedAt);
            final Duration diff = dt1.difference(dt2);
            final String timeAgo = diff.inDays == 0 ? "${diff.inHours}h" : "${diff.inDays}d";

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
                          _ReviewDetailHeader(avtUrl: reviewDetail.author.avatar, name: reviewDetail.author.name, timeAgo: timeAgo),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                if(reviewDetail.rating != null) Column(
                                  children: [
                                    Text("Đánh giá"),
                                    StarList(rating: reviewDetail.rating?.toDouble() ?? 0, color: Colors.orangeAccent),
                                  ],
                                ),
                                if(reviewDetail.rating != null) SizedBox(width: 24),
                                Container(
                                    width: reviewDetail.rating != null ? 250 : 348,
                                    child: Text("${reviewDetail.title}",
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
                          reviewDetail.classification != "Instruction" ?
                          Text("${reviewDetail.content}")
                              : ExpandableTextWidget(text: "${reviewDetail.content}", isHtml: true)
                        ]
                    ),
                  ),
                  const SizedBox(height: 4),
                  reviewDetail.images != null ?
                  Container(
                    height: 200,
                    child: GridView.count(
                      padding: EdgeInsets.all(0),
                      crossAxisCount: reviewDetail.images?.length == 1 ? 1 : 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: reviewDetail.images!.map((image) {
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
                  reviewDetail.video != null ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: ReviewDetailVideoContainer(url: reviewDetail.video?.url ?? VideoPlaceHolder.videoPlaceHolderOnline),
                  ) : const SizedBox.shrink(),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _ReviewDetailStats(
                        usefuls: reviewDetail.usefuls,
                        replies: reviewDetail.replies,
                        isSettedUseful: reviewDetail.isSettedUseful,
                        onSetUsefulReview: handleSetUsefulReview
                    ),
                  )
                ],
              ),
            );
          }
        }
      },
    );

  }
}

class _ReviewDetailHeader extends StatelessWidget {
  final String avtUrl;
  final String name;
  final String timeAgo;
  const _ReviewDetailHeader({Key? key, required this.avtUrl, required this.name, required this.timeAgo}) : super(key: key);

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
              RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(text: '$name ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis
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

          },
        )
      ],
    );
  }
}

class _ReviewDetailStats extends StatelessWidget {
  final int usefuls;
  final int replies;
  final bool isSettedUseful;
  final Function() onSetUsefulReview;
  final Function(Map event)? onHandleOtherReviewEvent;

  const _ReviewDetailStats({Key? key, required this.usefuls,  required this.replies, required this.isSettedUseful, required this.onSetUsefulReview, this.onHandleOtherReviewEvent}) : super(key: key);

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
              child: _ReviewDetailButton(
                icon: isSettedUseful? Icon(Icons.thumb_up, color: Colors.blue, size: 20) : Icon(Icons.thumb_up_outlined, color: Colors.grey[600], size: 20),
                label: 'Hữu ích',
                onTap: (){
                  onSetUsefulReview();
                },
              ),
            ),
            Expanded(
              child: _ReviewDetailButton(
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

class _ReviewDetailButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final VoidCallback onTap;
  const _ReviewDetailButton({Key? key, required this.icon, required this.label, required this.onTap}) : super(key: key);


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

class ReviewDetailVideoContainer extends StatefulWidget {
  final String url;
  ReviewDetailVideoContainer({Key? key, required this.url}) : super(key: key);

  @override
  State<ReviewDetailVideoContainer> createState() => _ReviewDetailVideoContainerState();
}

class _ReviewDetailVideoContainerState extends State<ReviewDetailVideoContainer> {
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
