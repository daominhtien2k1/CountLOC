import 'package:cosmetic_frontend/common/widgets/navigation_drawer_section.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../screens/screens.dart';

enum Screen { HomeScreen, NewsfeedScreen, RequestFriendScreen, WatchTab, PersonalScreen, NotificationScreen, MenuScreen }

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}


class _NavScreenState extends State<NavScreen> with TickerProviderStateMixin{
  late TabController _tabController;

  Screen _selectedScreenDestination = Screen.NewsfeedScreen;

  final Map<Screen, Widget> _cosmeticScreens = {
    Screen.HomeScreen: HomeScreen(),
    Screen.NewsfeedScreen: NewsFeedScreen(),
    Screen.WatchTab:  WatchTab(),
    Screen.PersonalScreen: PersonalScreen(),
    Screen.NotificationScreen: NotificationScreen(),
    Screen.MenuScreen: MenuScreen()
  };




  static final List<IconData> _icons = [
    Icons.home, Icons.feed, Icons.people, FontAwesomeIcons.gift, Icons.account_circle
  ];
  static final List<Widget> _screens = [
    HomeScreen(),
    NewsFeedScreen(),
    // WatchTab(),
    FriendScreen(),
    EventScreen(),
    PersonalScreen(),
  ];

  final List<Tab> _screenTabs = _icons.map((icon) => Tab(
    icon: Icon(icon,size: 30)
  )).toList();

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(vsync: this, length: 6, animationDuration: Duration.zero); // error due to animationDuration on Flutter 3.3.2
    _tabController = TabController(vsync: this, length: _screens.length);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final user = BlocProvider.of<AuthBloc>(context).state.authUser;
    // final token = user.token;
    // final userId = user.id;
    // print("$token, $userId");
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: _screens,
        physics: NeverScrollableScrollPhysics()
      ),
      drawer: NavigationDrawerSection(destination: _selectedScreenDestination),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: _screenTabs,
        indicator: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 3
            )
          )
        ),
        indicatorColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Colors.black45,
        labelColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
