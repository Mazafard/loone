import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final String idTo;
  final String messageID;
  final String idFrom;
  final Timestamp? timestamp;
  final int type;
  final bool isRead;
  final String content;
  final String length;

  Messages({
    required this.idTo,
    required this.messageID,
    required this.idFrom,
    required this.timestamp,
    required this.type,
    required this.content,
    required this.isRead,
    required this.length,
  });

  factory Messages.fromDocument(DocumentSnapshot doc) {
    return Messages(
      idTo: doc['idTo'],
      messageID: doc['messageID'],
      idFrom: doc['idFrom'],
      timestamp: doc['timestamp'],
      type: doc['type'],
      content: doc['content'],
      isRead: doc['isRead'],
      length: doc['length'],
    );
  }
}