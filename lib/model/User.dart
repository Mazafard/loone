import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String profileName;
  final String username;
  final String url;
  final String email;
  final String biography;
  final String chattingWith;
  final String pushToken;
  final bool isWriting;
  final bool isEnteredApp;

  User({
    required this.id,
    required this.profileName,
    required this.username,
    required this.url,
    required this.email,
    required this.biography,
    required this.chattingWith,
    required this.pushToken,
    required this.isWriting,
    required this.isEnteredApp,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      isEnteredApp: doc['isEnteredApp'],
      email: doc['email'],
      username: doc['username'],
      isWriting: doc['isWriting'],
      url: doc['url'],
      profileName: doc['profileName'],
      biography: doc['biography'],
      chattingWith: doc['chattingWith'],
      pushToken: doc['pushToken'],
    );
  }
}