import 'package:fumo/data/datasources/chat_remote_datasource.dart';
import 'package:fumo/domain/entities/message_entity.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/repositories/chat_repository.dart';
import 'package:pointycastle/export.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({required ChatRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;
  final ChatRemoteDataSource _remoteDataSource;
  @override Stream<List<UserEntity>> getUsersStream() => _remoteDataSource.getUsersStream();
  @override Future<void> sendMessage({required String receiverId, required String message, RSAPublicKey? recipientPublicKey}) => _remoteDataSource.sendMessage(receiverId: receiverId, message: message, recipientPublicKey: recipientPublicKey);
  @override Stream<List<MessageEntity>> getMessages({required String currentUserId, required String otherUserId, RSAPrivateKey? myPrivateKey}) => _remoteDataSource.getMessages(currentUserId: currentUserId, otherUserId: otherUserId, myPrivateKey: myPrivateKey);
  @override Stream<String?> getLastMessage({required String currentUserId, required String otherUserId}) => _remoteDataSource.getLastMessage(currentUserId: currentUserId, otherUserId: otherUserId);
  @override Future<void> savePublicKey(String userId, String encodedPublicKey) => _remoteDataSource.savePublicKey(userId, encodedPublicKey);
  @override Future<String?> getPublicKey(String userId) => _remoteDataSource.getPublicKey(userId);
  @override Future<void> deleteMessage({required String currentUserId, required String otherUserId, required String messageId}) => _remoteDataSource.deleteMessage(currentUserId: currentUserId, otherUserId: otherUserId, messageId: messageId);
  @override Future<void> updateMessage({required String currentUserId, required String otherUserId, required String messageId, required String newMessage}) => _remoteDataSource.updateMessage(currentUserId: currentUserId, otherUserId: otherUserId, messageId: messageId, newMessage: newMessage);
  @override Future<void> saveChatTheme({required String chatRoomId, required Map<String, dynamic> themeData}) => _remoteDataSource.saveChatTheme(chatRoomId: chatRoomId, themeData: themeData);
  @override Stream<Map<String, dynamic>?> watchChatTheme({required String chatRoomId}) => _remoteDataSource.watchChatTheme(chatRoomId: chatRoomId);
}
