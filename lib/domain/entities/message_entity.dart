import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  const MessageEntity({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.id,
    // Поля для E2E шифрования
    this.encryptedKey,
    this.ciphertext,
    this.iv,
  });

  final String? id;
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  /// Зашифрованный AES-ключ (RSA-2048), Base64
  final String? encryptedKey;

  /// Зашифрованное сообщение (AES-256-CBC), Base64
  final String? ciphertext;

  /// Вектор инициализации для AES, Base64
  final String? iv;

  /// Флаг: сообщение зашифровано
  bool get isEncrypted => ciphertext != null && iv != null;

  @override
  List<Object?> get props => [
        id,
        senderId,
        senderEmail,
        receiverId,
        message,
        timestamp,
        encryptedKey,
        ciphertext,
        iv,
      ];
}
