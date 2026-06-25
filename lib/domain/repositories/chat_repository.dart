import 'package:fumo/domain/entities/message_entity.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:pointycastle/export.dart';

abstract class ChatRepository {
  Stream<List<UserEntity>> getUsersStream();
  Future<void> sendMessage({required String receiverId, required String message, RSAPublicKey? recipientPublicKey});
  Stream<List<MessageEntity>> getMessages({required String currentUserId, required String otherUserId, RSAPrivateKey? myPrivateKey});
  Stream<String?> getLastMessage({required String currentUserId, required String otherUserId});
  Future<void> savePublicKey(String userId, String encodedPublicKey);
  Future<String?> getPublicKey(String userId);
  Future<void> deleteMessage({required String currentUserId, required String otherUserId, required String messageId});
  Future<void> updateMessage({required String currentUserId, required String otherUserId, required String messageId, required String newMessage});
}
