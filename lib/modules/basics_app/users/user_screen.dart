import 'package:flutter/material.dart';
import 'package:flutter_app/models/user/user_model.dart';

class UserScreen extends StatelessWidget {
  List<UserModel> users = [
    UserModel(username: 'Mustafa Mahmoud', id: '1', phone: '+1006989546'),
    UserModel(username: 'Mariam Mahmoud', id: '2', phone: '+1153861415'),
    UserModel(username: 'Eman Mahmoud', id: '3', phone: '+1023654896'),
    UserModel(username: 'Aya Mahmoud', id: '4', phone: '+2135462121'),
    UserModel(username: 'Mustafa Mahmoud', id: '1', phone: '+1006989546'),
    UserModel(username: 'Mariam Mahmoud', id: '2', phone: '+1153861415'),
    UserModel(username: 'Eman Mahmoud', id: '3', phone: '+1023654896'),
    UserModel(username: 'Aya Mahmoud', id: '4', phone: '+2135462121'),
    UserModel(username: 'Mustafa Mahmoud', id: '1', phone: '+1006989546'),
    UserModel(username: 'Mariam Mahmoud', id: '2', phone: '+1153861415'),
    UserModel(username: 'Eman Mahmoud', id: '3', phone: '+1023654896'),
    UserModel(username: 'Aya Mahmoud', id: '4', phone: '+2135462121'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => buildUserItem(users[index]),
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsetsDirectional.only(start: 20.0),
          child: Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
        ),
        itemCount: users.length,
      ),
    );
  }

  Widget buildUserItem(UserModel user) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              child: Text(
                '${user.id}',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              radius: 25.0,
            ),
            SizedBox(
              width: 15.0,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.username}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '${user.phone}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
