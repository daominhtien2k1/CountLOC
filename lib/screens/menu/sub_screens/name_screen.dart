import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/localdata/local_data.dart';

class ChangeNameScreen extends StatelessWidget {
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
        title: Text('Name',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(12.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
                    child: Text('Name',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                  Divider(height: 0.0, thickness: 2.0),
                  Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Your name ${currentUser.name} will also be updated on Instagram.',
                              style: TextStyle(fontSize: 15.0),
                            )),
                        _Name_Properties(
                            propertyName: 'First name', currentValue: 'Hoang'),
                        _Name_Properties(
                            propertyName: 'Middle name', currentValue: null),
                        _Name_Properties(
                            propertyName: 'Last name',
                            currentValue: 'Dep trai'),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          child: Text.rich(TextSpan(
                              text: 'Please note: ',
                              style: TextStyle(
                                  height: 1.4,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        "If you change your name on Facebook or Instagram, you can't change it again for 60 days. Don't add any unusual capitalization, punctuation , characters, or random words.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal))
                              ])),
                        ),
                        Container(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                OutlinedButton(
                                  onPressed: () => print('Review Change'),
                                  child: Text(
                                    'Review Change',
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.white),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      minimumSize: Size(double.infinity, 45.0)),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                OutlinedButton(
                                  onPressed: () => print('Cancel'),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      minimumSize: Size(double.infinity, 45.0)),
                                ),
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Name_Properties extends StatelessWidget {
  final String propertyName;
  final String? currentValue;

  const _Name_Properties(
      {Key? key, required this.propertyName, this.currentValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            propertyName,
            style: TextStyle(fontSize: 15.0),
          ),
          SizedBox(height: 2.0),
          TextField(
              decoration: InputDecoration(
                  constraints:
                      BoxConstraints.tightFor(width: 250.0, height: 40.0),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                  border: OutlineInputBorder(),
                  hintText: currentValue))
        ],
      ),
    );
  }
}
