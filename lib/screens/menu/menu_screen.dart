import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/personal_info/personal_info_bloc.dart';
import '../../blocs/personal_info/personal_info_event.dart';
import '../../blocs/personal_info/personal_info_state.dart';

import './widgets/menu_widgets.dart';
import './sub_screens/menu_subscreens.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> handleLogout() async {
      context
          .read<PersonalInfoBloc>();
      BlocProvider.of<AuthBloc>(context).add(Logout());
      // dù câu lệnh ở đằng sau nhưng vì là bất đồng bộ nên vẫn là AuthStatus.authenticated
      // print("Logout getUser: " + user.toString());
    }
    return Scaffold(
        body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: const Text(
              'Menu',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            floating: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            actions: [
              CircleButton(
                  icon: Icons.search,
                  iconSize: 30.0,
                  onPressed: () => print('Search')),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(12.0),
              color: Colors.grey[200],
              child: Column(
                children: [
                  TextButton(
                    onPressed: () => print('See profile'),
                    child: Row(
                      children: [
                        Avatar(),
                        const SizedBox(width: 12.0),
                        Expanded(
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UserName(),
                              const Text(
                                'See your profile',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                        ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Divider(height: 10.0, thickness: 2),
                  ExpansionTile(
                    title: const Text('Help & Support',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    leading:
                        const Icon(Icons.help, size: 35.0, color: Colors.black),
                    children: [
                      ActionButton(
                          icon: Icons.policy,
                          buttonText: 'Terms & Policies',
                          onPressed: () => print('object')),
                      const SizedBox(height: 8.0),
                      // _ActionButton(
                      //     icon: Icons.help_center, buttonText: 'Help Center'),
                      // SizedBox(height: 8.0),
                    ],
                  ),
                  // const Divider(height: 10.0, thickness: 2),
                  ExpansionTile(
                    title: const Text('Settings & Privacy',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    leading: const Icon(Icons.settings,
                        size: 35.0, color: Colors.black),
                    children: [
                      ActionButton(
                        icon: Icons.admin_panel_settings,
                        buttonText: 'Settings',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsScreen()));
                        },
                      ),
                      const SizedBox(height: 8.0),
                      ActionButton(
                        icon: Icons.lock_person_sharp,
                        buttonText: 'Privacy',
                        onPressed: () => print('object'),
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                  // const Divider(height: 10.0, thickness: 2),
                  ExpansionTile(
                    title: const Text('Log out',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    leading:
                        const Icon(Icons.close, size: 35.0, color: Colors.black),
                    children: [
                      ActionButton(
                        icon: Icons.logout,
                        buttonText: 'Log out',
                        onPressed: () {
                          handleLogout();
                        },
                      ),
                      const SizedBox(height: 8.0),
                      ActionButton(
                        icon: Icons.exit_to_app,
                        buttonText: 'Close app',
                        onPressed: () => exit(0),
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                  // ),
                ],
              ),
            ),
          )
        ],
    ));
  }
}

class UserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return Text(userInfo.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black));
        });
  }
}

class Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<PersonalInfoBloc>().add(PersonalInfoFetched());

    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return ProfileAvatar(imageUrl: userInfo.avatar);
        });
  }
}