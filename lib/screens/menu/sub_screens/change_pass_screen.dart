import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text('Change Password',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 25.0),
              color: Colors.white,
              child: Column(
                children: [
                  TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_person_rounded,
                              color: Colors.black),
                          enabledBorder: OutlineInputBorder(),
                          constraints: BoxConstraints.tightFor(
                              width: double.infinity, height: 50.0),
                          hintText: 'Current password'),
                      obscureText: true),
                  SizedBox(height: 10.0),
                  TextField(
                      decoration: InputDecoration(
                          prefixIcon:
                          Icon(Icons.key_rounded, color: Colors.black),
                          enabledBorder: OutlineInputBorder(),
                          constraints: BoxConstraints.tightFor(
                              width: double.infinity, height: 50.0),
                          hintText: 'New password'),
                      obscureText: true),
                  SizedBox(height: 10.0),
                  TextField(
                      decoration: InputDecoration(
                          prefixIcon:
                          Icon(Icons.key_rounded, color: Colors.black),
                          enabledBorder: OutlineInputBorder(),
                          constraints: BoxConstraints.tightFor(
                              width: double.infinity, height: 50.0),
                          hintText: 'Re-type new password'),
                      obscureText: true),
                  SizedBox(height: 10.0),
                  OutlinedButton(
                    onPressed: () => print('Update password'),
                    child: Text(
                      'Update password',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
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
                      style: TextStyle(fontSize: 18.0),
                    ),
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 45.0)),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () => print('Forgot password?'),
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
