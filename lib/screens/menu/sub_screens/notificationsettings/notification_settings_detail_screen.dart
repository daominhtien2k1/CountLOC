import 'package:flutter/material.dart';

class NotificationSettingsDetailScreen extends StatelessWidget {
  String _title = "";

  static final Map<String, IconData> _icons = {
    'notifications': Icons.notifications,
    'email': Icons.email_outlined,
    'sms': Icons.sms,
  };

  static final Map<String, String> _titles = {
    'notifications': 'Thông báo đẩy',
    'email': 'Email',
    'sms': 'SMS',
  };

  NotificationSettingsDetailScreen(String str) : super() {
    this._title = str;
  }

  ListTile tileCus(String str) {
    return ListTile(
      title: Text(_titles[str]!),
      leading: Icon(_icons[str]),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: Text(this._title, style: TextStyle(color: Colors.black)),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        ),
        body: ListView(
          children: [
            const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Nơi bạn nhận các thông báo này',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                )),

            tileCus('notifications'),
            tileCus('email'),
            tileCus('sms'),
          ],
        ));
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.red,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}
