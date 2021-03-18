import 'dart:io';

class User {
  final String username;
  final String email;
  final File image;
  final bool isAdmin;
  User({this.username,this.email,this.isAdmin,this.image});
}