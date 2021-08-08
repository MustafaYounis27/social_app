import 'package:flutter/material.dart';

class UserModel {
  final String username;
  final String id;
  final String phone;

  UserModel({
    @required this.username,
    @required this.id,
    @required this.phone,
  });
}