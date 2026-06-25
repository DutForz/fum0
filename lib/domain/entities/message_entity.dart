import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  const MessageEntity({required this.senderId, required this.senderEmail, required this.receiverId, required this.message, required this.timestamp, this.id, this.encryptedKey, this.ciphertext, this.iv});
  final String? id;
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final String? encryptedKey;
  final String? ciphertext;
  final String? iv;
  bool get isEncrypted => ciphertext != null && iv != null;
  @override List<Object?> get props => [id, senderId, senderEmail, receiverId, message, timestamp, encryptedKey, ciphertext, iv];
}
