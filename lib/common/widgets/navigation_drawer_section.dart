

import 'package:cosmetic_frontend/screens/menu/menu_screen.dart';
import 'package:cosmetic_frontend/screens/nav_screen.dart';
import 'package:flutter/material.dart';

class NavigationDrawerItem {
  const NavigationDrawerItem(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<NavigationDrawerItem> destinations = <NavigationDrawerItem>[
  NavigationDrawerItem('Personal information', Icon(Icons.inbox_outlined, color: Colors.amber), Icon(Icons.inbox)),
  NavigationDrawerItem('Your prescription', Icon(Icons.send_outlined), Icon(Icons.send)),
  NavigationDrawerItem(
      'Favorites', Icon(Icons.favorite_outline), Icon(Icons.favorite)),
  NavigationDrawerItem('Guardian', Icon(Icons.delete_outline), Icon(Icons.delete)),
  NavigationDrawerItem('Discover drug', Icon(Icons.delete_outline), Icon(Icons.delete)),
  NavigationDrawerItem('Medical store', Icon(Icons.delete_outline), Icon(Icons.delete)),
  NavigationDrawerItem('AI health assistant', Icon(Icons.delete_outline), Icon(Icons.delete)),
  NavigationDrawerItem('Menu', Icon(Icons.menu_outlined), Icon(Icons.menu)),
  NavigationDrawerItem('Logout', Icon(Icons.delete_outline), Icon(Icons.delete)),
];



class NavigationDrawerSection extends StatefulWidget {
  final Screen destination;

  const NavigationDrawerSection({super.key, required this.destination});

  @override
  State<NavigationDrawerSection> createState() =>
      _NavigationDrawerSectionState();
}

class _NavigationDrawerSectionState extends State<NavigationDrawerSection> {
  int navDrawerIndex = 0;

  @override
  void initState() {
    super.initState();


  }

  @override
  void didUpdateWidget(covariant NavigationDrawerSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.destination != oldWidget.destination) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: (selectedIndex) {
        setState(() {
          navDrawerIndex = selectedIndex;
        });
        if (selectedIndex == 7) {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => MenuScreen()));
        }
      },
      selectedIndex: navDrawerIndex,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  child: Icon(Icons.account_circle),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Đào Minh Tiến",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary)
                    ),
                    Text("tien.dm190070@sis.hust.edu.vn")
                  ],
                )
              ],
            )
        ),
        const Divider(indent: 28, endIndent: 28),
        ...destinations.map((destination) {
          return NavigationDrawerDestination(
            label: Text(destination.label),
            icon: destination.icon,
            selectedIcon: destination.selectedIcon,
          );
        }),
      ],
    );
  }
}