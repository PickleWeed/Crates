import 'dart:io';

class User {
  final String userID;
  final String username;
  final String email;
  final bool isAdmin;
  final String imagePath;
  // 0 = No, 1 = Banned for 30 days, 2 = Banned forever
  final String isBanned;
  // bannedFrom will show the date the ban started
  final DateTime bannedFrom;

  User({this.userID, this.username, this.email, this.isAdmin, this.imagePath, this.isBanned, this.bannedFrom});
//User({this.username,this.email,this.isAdmin,this.image});
  User.fromData(Map<String, dynamic> data)
      : userID = data['userID'],
        username = data['username '],
        email = data['email'],
        isAdmin = data['isAdmin'],
        imagePath = data['imagePath'],
        isBanned = data['isBanned'],
        bannedFrom = DateTime.parse(data['bannedFrom']);

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'username': username,
      'email': email,
      'isAdmin': isAdmin,
      'image' : imagePath
    };
  }
}