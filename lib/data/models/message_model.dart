import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fumo/core/crypto/crypto_service.dart';
import 'package:fumo/domain/entities/message_entity.dart';
import 'package:pointycastle/export.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    super.id,
    required super.senderId,
    required super.senderEmail,
    required super.receiverId,
    required super.message,
    required super.timestamp,
    super.encryptedKey,
    super.ciphertext,
    super.iv,
  });
  factory MessageModel.fromFirestore(
    DocumentSnapshot doc, {
    RSAPrivateKey? myPrivateKey,
  }) {
    final data = doc.data()! as Map<String, dynamic>;
    final ciphertext = data['ciphertext'] as String?;
    final iv = data['iv'] as String?;
    final encryptedKey = data['encryptedKey'] as String?;
    String message;
    if (ciphertext != null && iv != null && encryptedKey != null) {
      if (myPrivateKey != null) {
        try {
          message = CryptoService.decryptFromSender({
            'encryptedKey': encryptedKey,
            'ciphertext': ciphertext,
            'iv': iv,
          }, myPrivateKey);
        } catch (_) {
          message = 'Encrypted message';
        }
      } else {
        message = 'Encrypted message';
      }
    } else {
      message = data['message'] as String? ?? '';
    }
    return MessageModel(
      id: doc.id,
      senderId: data['senderID'] as String,
      senderEmail: data['senderEmail'] as String? ?? '',
      receiverId: data['receiverID'] as String,
      message: message,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      ciphertext: ciphertext,
      iv: iv,
      encryptedKey: encryptedKey,
    );
  }
  Map<String, dynamic> toMap({RSAPublicKey? recipientPublicKey}) {
    final map = <String, dynamic>{
      'senderID': senderId,
      'senderEmail': senderEmail,
      'receiverID': receiverId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
    if (recipientPublicKey != null) {
      final encrypted = CryptoService.encryptForRecipient(
        message,
        recipientPublicKey,
      );
      map['ciphertext'] = encrypted['ciphertext'];
      map['iv'] = encrypted['iv'];
      map['encryptedKey'] = encrypted['encryptedKey'];
      map['message'] = '';
    } else {
      map['message'] = message;
    }
    return map;
  }
}
