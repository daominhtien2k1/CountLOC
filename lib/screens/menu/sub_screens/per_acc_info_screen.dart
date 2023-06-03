import 'package:flutter/material.dart';

import '../../../constants/localdata/local_data.dart';
import 'menu_subscreens.dart';

class PersonalAccountInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(17.0, 20.0, 17.0, 5.0),
              color: Colors.white,
              child: const Text(
                'Personal and account information',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNameScreen()));
              },
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
                child: Row(
                  children: [
                    Icon(Icons.person_pin_rounded,
                        size: 30.0, color: Colors.grey[600]),
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text('${currentUser.name}')
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.navigate_next_rounded,
                        color: Colors.black, size: 40.0)
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Divider(
            height: 2.0,
            thickness: 20.0,
          )),
        ],
      ),
    );
  }
}
