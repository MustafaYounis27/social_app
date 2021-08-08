import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: Icon(
          Icons.menu,
        ),
        title: Text(
          'title',
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
            ),
            onPressed: () {
              print('notification clicked');
            },
          ),
          IconButton(
            icon: Text(
              'hello',
            ),
            onPressed: () {
              print('Hello!');
            },
          ),
        ],
      ),
      body: Text(
        'hello world!',
      ),
    );
  }
}
