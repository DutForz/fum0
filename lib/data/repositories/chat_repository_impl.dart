import 'package:fumo/data/datasources/chat_remote_datasource.dart';
import 'package:fumo/domain/entities/message_entity.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({required ChatRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final ChatRemoteDataSource _remoteDataSource;

  @override
  Stream<List<UserEntity>> getUsersStream() {
    return _remoteDataSource.getUsersStream();
  }

  @override
  Future<void> sendMessage({
    required String receiverId,
    required String message,
  }) {
    return _remoteDataSource.sendMessage(
      receiverId: receiverId,
      message: message,
    );
  }

  @override
  Stream<List<MessageEntity>> getMessages({
    required String currentUserId,
    required String otherUserId,
  }) {
    return _remoteDataSource.getMessages(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    );
  }

  @override
  Stream<String?> getLastMessage({
    required String currentUserId,
    required String otherUserId,
  }) {
    return _remoteDataSource.getLastMessage(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    );
  }
}
