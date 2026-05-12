import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID, senderEmail, receiverID, message;
  final Timestamp timestamp;
  Message({
    required this.message,
    required this.senderEmail,
    required this.receiverID,
    required this.senderID,
    required this.timestamp,
  });
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': receiverID,
      'message': message,
      'receiverID': receiverID,
      'timestamp': timestamp,
    };
  }
}
