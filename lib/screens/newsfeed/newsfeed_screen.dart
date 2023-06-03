import 'package:cosmetic_frontend/screens/newsfeed/newsfeed_question_screen_content.dart';
import 'package:cosmetic_frontend/screens/newsfeed/newsfeed_share_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:cosmetic_frontend/screens/newsfeed/newsfeed_general_screen_content.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  @override
  Widget build(BuildContext context) {
      return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Cosmestica',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Chung",
                ),
                Tab(
                  text: "Góc hỏi đáp",
                ),
                Tab(
                  text: "Chia sẻ kinh nghiệm",
                ),
              ],
            ),
          ),
          body: TabBarView(
            // physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              NewsfeedGeneralScreenContent(),
              NewsfeedQuestionScreenContent(),
              NewsfeedShareScreenContent()
            ],
          ),
        ),

      );
  }
}

