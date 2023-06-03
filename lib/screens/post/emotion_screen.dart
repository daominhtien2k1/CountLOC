import 'package:flutter/material.dart';

import './widgets/post_widgets.dart';

class EmotionScreen extends StatefulWidget  {
  EmotionScreen({Key? key}) : super(key: key);

  @override
  State<EmotionScreen> createState() => _EmotionScreenState();
}

class _EmotionScreenState extends State<EmotionScreen> {
  String? status;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  handleChangeStatus (String value) {
    setState(() {
      status = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("#Emotion_screen receiver: $status");
    // print("#Emotion_screen: $status");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PostAppbar(
          title: 'Bạn thế nào rồi?',
          action: 'Xong',
          extras: {'status': status},
        ),
        body: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black, width: 0.2),
                  bottom: BorderSide(color: Colors.black, width: 0.2)
                )
              ),
              child: const TabBar(
                  tabs: <Widget>[
                    Tab(
                      text: 'Cảm xúc',
                    ),
                    Tab(
                      text: 'Hoạt động',
                    )
                  ],
                  indicatorColor: Colors.blue,
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.black,
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Hiện đang cảm thấy... ',  style: TextStyle(color: Colors.black, fontSize: 16)),
                    if(status != null) TextSpan(text: '$status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                  ],
                ),
                // maxLines: 2,
                // overflow: TextOverflow.ellipsis
              ),
            ),
            Expanded(
                child: TabBarView(
                  children: [
                    EmotionGrid(onHandleChangeStatus: handleChangeStatus),
                    ActivityGrid()
                  ],
                )
            )
          ],

        ),
    )
    );
  }
}

class EmotionGrid extends StatelessWidget {
  final Function(String value) onHandleChangeStatus;

  const EmotionGrid({Key? key, required this.onHandleChangeStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emotionArray = [
      {'icon': '🙂', 'value': 'hạnh phúc'},
      {'icon': '😇', 'value': 'có phúc'},
      {'icon': '🥰', 'value': 'được yêu'},
      {'icon': '🙁', 'value': 'buồn'},
      {'icon': '🥰', 'value': 'đáng yêu'},
      {'icon': '😀', 'value': 'biết ơn'},
      {'icon': '🤩', 'value': 'hào hứng'},
      {'icon': '🥰', 'value': 'đang yêu'},
      {'icon': '🤪', 'value': 'điên'},
      {'icon': '😊', 'value': 'cảm kích'},
      {'icon': '☺', 'value': 'sung sướng'},
      {'icon': '😁', 'value': 'tuyệt vời'},
      {'icon': '🤪', 'value': 'ngốc nghếch'},
      {'icon': '😙', 'value': 'vui vẻ'},
      {'icon': '🤩', 'value': 'tuyệt vời'},
      {'icon': '😎', 'value': 'thật phong cách'},
      {'icon': '😉', 'value': 'thú vị'},
      {'icon': '😬', 'value': 'thư giãn'},
      {'icon': '😉', 'value': 'positive'},
      {'icon': '😬', 'value': 'rùng mình'},
      {'icon': '🤗', 'value': 'đầy hi vọng'},
      {'icon': '🤗', 'value': 'hân hoan'},
      {'icon': '😓', 'value': 'mệt mỏi'},
      {'icon': '🤩', 'value': 'có động lực'},
      {'icon': '☺', 'value': 'proud'},
      {'icon': '😩', 'value': 'chỉ có một mình'},
      {'icon': '☺', 'value': 'chu đáo'},
      {'icon': '👌', 'value': 'OK'},
      {'icon': '🤕', 'value': 'nhớ nhà'},
      {'icon': '😡', 'value': 'giận dữ'},
      {'icon': '🤒', 'value': 'ốm yếu'},
      {'icon': '😊', 'value': 'hài lòng'},
      {'icon': '😩', 'value': 'kiệt sức'},
      {'icon': '🥺', 'value': 'xúc động'},
      {'icon': '🤩', 'value': 'tự tin'},
      {'icon': '😁', 'value': 'rất tuyệt'},
      {'icon': '😉', 'value': 'tươi mới'},
      {'icon': '😤', 'value': 'quyết đoán'},
      {'icon': '😩', 'value': 'kiệt sức'},
      {'icon': '😠', 'value': 'bực mình'},
      {'icon': '😄', 'value': 'vui vẻ'},
      {'icon': '🤑', 'value': 'gặp may'},
      {'icon': '😔', 'value': 'đau khổ'},
      {'icon': '😔', 'value': 'buồn tẻ'},
      {'icon': '😴', 'value': 'buồn ngủ'},
      {'icon': '🤩', 'value': 'tràn đầy sinh lực'},
      {'icon': '🤤', 'value': 'đói'},
      {'icon': '😎', 'value': 'chuyên nghiệp'},
      {'icon': '😵', 'value': 'đau đớn'},
      {'icon': '😌', 'value': 'thanh thản'},
      {'icon': '😔', 'value': 'thất vọng'},
      {'icon': '😚', 'value': 'lạc quan'},
      {'icon': '🥶', 'value': 'lạnh'},
      {'icon': '🥺', 'value': 'dễ thương'},
      {'icon': '🤩', 'value': 'tuyệt cú mèo'},
      {'icon': '😊', 'value': 'thật tuyệt'},
      {'icon': '😧', 'value': 'hối tiếc'},
      {'icon': '😝', 'value': 'thật giỏi'},
      {'icon': '🙁', 'value': 'lo lắng'},
      {'icon': '😁', 'value': 'vui nhộn'},
      {'icon': '🥺', 'value': 'tồi tệ'},
      {'icon': '😔', 'value': 'xuống tinh thần'},
      {'icon': '😚', 'value': 'đầy cảm hứng'},
      {'icon': '☺', 'value': 'hài lòng'},
      {'icon': '😄', 'value': 'phấn khích'},
      {'icon': '😐', 'value': 'bình tĩnh'},
      {'icon': '😕', 'value': 'bối rối'},
      {'icon': '😟', 'value': 'goofy'},
      {'icon': '😔', 'value': 'trống vắng'},
      {'icon': '🙂', 'value': 'tốt'},
      {'icon': '😏', 'value': 'mỉa mai'},
      {'icon': '😔', 'value': 'cô đơn'},
      {'icon': '😤', 'value': 'mạnh mẽ'},
      {'icon': '😟', 'value': 'lo lắng'},
      {'icon': '😌', 'value': 'đặc biệt'},
      {'icon': '😟', 'value': 'chán nản'},
      {'icon': '😁', 'value': 'vui vẻ'},
      {'icon': '😮', 'value': 'tò mò'},
      {'icon': '😟', 'value': 'ủ dột'},
      {'icon': '🤗', 'value': 'được chào đón'},
      {'icon': '🤕', 'value': 'gục ngã'},
      {'icon': '🥰', 'value': 'xinh đẹp'},
      {'icon': '🥰', 'value': 'tuyệt vời'},
      {'icon': '🤬', 'value': 'cáu'},
      {'icon': '😠', 'value': 'căng thẳng'},
      {'icon': '😟', 'value': 'thiếu'},
      {'icon': '🤬', 'value': 'kích động'},
      {'icon': '🤪', 'value': 'tinh quái'},
      {'icon': '😮', 'value': 'kinh ngạc'},
      {'icon': '😡', 'value': 'tức giận'},
      {'icon': '😩', 'value': 'buồn chán'},
      {'icon': '😕', 'value': 'bối rồi'},
      {'icon': '😤', 'value': 'mạnh mẽ'},
      {'icon': '🤬', 'value': 'phẫn nộ'},
      {'icon': '😙', 'value': 'mới mẻ'},
      {'icon': '😁', 'value': 'thành công'},
      {'icon': '😮', 'value': 'ngạc nhiên'},
      {'icon': '😕', 'value': 'bối rối'},
      {'icon': '😔', 'value': 'nản lòng'},
      {'icon': '😒', 'value': 'tẻ nhạt'},
      {'icon': '🥰', 'value': 'xinh xắn'},
      {'icon': '🤗', 'value': 'khá hơn'},
      {'icon': '😳', 'value': 'tội lỗi'},
      {'icon': '🤗', 'value': 'an toàn'},
      {'icon': '😚', 'value': 'tự do'},
      {'icon': '😕', 'value': 'hoang mang'},
      {'icon': '👴', 'value': 'già nua'},
      {'icon': '😪', 'value': 'lười biếng'},
      {'icon': '😰', 'value': 'tồi tệ hơn'},
      {'icon': '😵', 'value': 'khủng khiếp'},
      {'icon': '😌', 'value': 'thoải mái'},
      {'icon': '😜', 'value': 'ngớ ngẩn'},
      {'icon': '😳', 'value': 'hổ thẹn'},
      {'icon': '🤮', 'value': 'kinh khủng'},
      {'icon': '😴', 'value': 'đang ngủ'},
      {'icon': '💪', 'value': 'khỏe'},
      {'icon': '🦵', 'value': 'nhanh nhẹn'},
      {'icon': '😳', 'value': 'ngại ngùng'},
      {'icon': '😷', 'value': 'gay go'},
      {'icon': '🤨', 'value': 'kỳ lạ'},
      {'icon': '😶', 'value': 'như con người'},
      {'icon': '😢', 'value': 'bị tổn thương'},
      {'icon': '😱', 'value': 'khủng khiếp'}
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 5),
      ),
      itemCount: emotionArray.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            final status = emotionArray[index]["value"]!;
            onHandleChangeStatus(status);
          },
          child: GridTile(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              decoration: BoxDecoration(
                border: Border.all(width: 0.05, color: Colors.grey)
              ),
              child: Row(
                children: [
                  Text(emotionArray[index]["icon"] as String),
                  SizedBox(width: 6),
                  Text(emotionArray[index]["value"] as String)
                ],
              ),
            )
          ),
        );
      },
    );
  }
}

class ActivityGrid extends StatelessWidget {
  const ActivityGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activityArray = [
      {'icon': '🥳', 'value': 'Đang chúc mừng...'},
      {'icon': '🍪', 'value': 'Đang ăn...'},
      {'icon': '🙋', 'value': 'Đang tham gia...'},
      {'icon': '🎵', 'value': 'Đang nghe...'},
      {'icon': '💭', 'value': 'Đang nghĩ về...'},
      {'icon': '🎮', 'value': 'Đang chơi...'},
      {'icon': '🎥', 'value': 'Đang xem...'},
      {'icon': '🍹', 'value': 'Đang uống...'},
      {'icon': '✈', 'value': 'Đang đi tới....'},
      {'icon': '🔎', 'value': 'Đang tìm...'},
      {'icon': '📖', 'value': 'Đang đọc'},
      {'icon': '💝', 'value': 'Đang ủng hộ...'}
    ];
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 5),
      ),
      itemCount: activityArray.length,
      itemBuilder: (context, index) {
        return GridTile(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.05, color: Colors.grey)
              ),
              child: Row(
                children: [
                  Text(activityArray[index]["icon"] as String),
                  SizedBox(width: 6),
                  Text(activityArray[index]["value"] as String)
                ],
              ),
            )
        );
      },
    );
  }
}





