import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fumo/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    super.id,
    required super.senderId,
    required super.senderEmail,
    required super.receiverId,
    required super.message,
    required super.timestamp,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      senderId: data['senderID'] as String,
      senderEmail: data['senderEmail'] as String? ?? '',
      receiverId: data['receiverID'] as String,
      message: data['message'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderId,
      'senderEmail': senderEmail,
      'message': message,
      'receiverID': receiverId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
