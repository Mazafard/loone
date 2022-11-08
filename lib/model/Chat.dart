import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String lastContent;
  final String id;
  final String url;
  final Timestamp? timestamp;
  final String username;
  final String profileName;
  final bool isEntered;
  final String messageID;
  final String idFrom;

  Chat({
    required this.lastContent,
    required this.id,
    required this.messageID,
    required this.idFrom,
    required this.url,
    required this.timestamp,
    required this.username,
    required this.profileName,
    required this.isEntered,
  });

  factory Chat.fromDocument(DocumentSnapshot doc) {
    return Chat(
      lastContent: doc['lastContent'],
      messageID: doc['messageID'],
      isEntered: doc['isEntered'],
      idFrom: doc['idFrom'],
      id: doc['id'],
      url: doc['url'],
      timestamp: doc['timestamp'],
      username: doc['username'],
      profileName: doc['profileName'],
    );
  }
}
