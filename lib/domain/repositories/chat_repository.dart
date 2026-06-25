import 'package:fumo/domain/entities/message_entity.dart';
import 'package:fumo/domain/entities/user_entity.dart';

abstract class ChatRepository {
  Stream<List<UserEntity>> getUsersStream();

  Future<void> sendMessage({
    required String receiverId,
    required String message,
  });

  Stream<List<MessageEntity>> getMessages({
    required String currentUserId,
    required String otherUserId,
  });

  Stream<String?> getLastMessage({
    required String currentUserId,
    required String otherUserId,
  });
}
