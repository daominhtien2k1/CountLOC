import 'package:flutter/material.dart';

import 'menu_subscreens.dart';
import './notificationsettings/notification_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Settings & privacy',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0.0, 17.0, 0.0, 2.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Settings_Description(
                      settingsName: 'Account',
                      settingsDes:
                      'Update your info to keep your account secure'),
                  const SizedBox(height: 5.0),
                  _SettingsButton(
                      onPressed: () =>
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PersonalAccountInfo()))
                      },
                      icon: Icons.account_circle,
                      buttonName: 'Personal and account information')
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 17.0, 0.0, 2.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _Settings_Description(
                        settingsName: 'Security',
                        settingsDes:
                        'Change your password and take other actions to increase the security of your account'),
                    const SizedBox(height: 5.0),
                    _SettingsButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PasswordAndSecurity()));
                        },
                        icon: Icons.shield_outlined,
                        buttonName: 'Password and security')
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(0.0, 17.0, 0.0, 2.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _Settings_Description(
                        settingsName: 'Preferences',
                        settingsDes: 'Customize your experience on Facebook'),
                    const SizedBox(height: 5.0),
                    _SettingsButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationSettingsScreen()));
                        },
                        icon: Icons.notifications_none,
                        buttonName: 'Notifications')
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Settings_Description extends StatelessWidget {
  final String settingsName;
  final String settingsDes;

  const _Settings_Description(
      {Key? key, required this.settingsName, required this.settingsDes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            settingsName,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 3.0,
          ),
          Text(
            settingsDes,
            style: TextStyle(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final IconData icon;
  final String buttonName;
  final void Function()? onPressed;

  const _SettingsButton(
      {Key? key, required this.icon, required this.buttonName, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: onPressed,
        style: ButtonStyle(
            alignment: Alignment.centerLeft,
            padding: MaterialStateProperty.all(EdgeInsets.all(12.0))),
        icon: Icon(
          icon,
          size: 28.0,
          color: Colors.black,
        ),
        label: Text(
          buttonName,
          style: TextStyle(
              fontSize: 17.0, color: Colors.black, fontWeight: FontWeight.w500),
        ));
  }
}
