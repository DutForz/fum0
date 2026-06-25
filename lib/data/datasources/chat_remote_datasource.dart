import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fumo/core/constants/firestore_constants.dart';
import 'package:fumo/data/models/message_model.dart';
import 'package:fumo/data/models/user_model.dart';
import 'package:pointycastle/export.dart';

abstract class ChatRemoteDataSource {
  Stream<List<UserModel>> getUsersStream();

  Future<void> sendMessage({
    required String receiverId,
    required String message,
    RSAPublicKey? recipientPublicKey,
  });

  Stream<List<MessageModel>> getMessages({
    required String currentUserId,
    required String otherUserId,
    RSAPrivateKey? myPrivateKey,
  });

  Stream<String?> getLastMessage({
    required String currentUserId,
    required String otherUserId,
  });

  /// Сохраняет публичный RSA-ключ пользователя в Firestore
  Future<void> savePublicKey(String userId, String encodedPublicKey);

  /// Получает публичный RSA-ключ пользователя из Firestore
  Future<String?> getPublicKey(String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _auth = firebaseAuth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String _chatRoomId(String userId, String otherUserId) {
    final ids = [userId, otherUserId]..sort();
    return ids.join('_');
  }

  @override
  Stream<List<UserModel>> getUsersStream() {
    return _firestore
        .collection(FirestoreConstants.usersCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap(doc.data()))
              .toList(),
        );
  }

  @override
  Future<void> sendMessage({
    required String receiverId,
    required String message,
    RSAPublicKey? recipientPublicKey,
  }) async {
    final currentUser = _auth.currentUser!;
    final newMessage = MessageModel(
      senderId: currentUser.uid,
      senderEmail: currentUser.email ?? '',
      receiverId: receiverId,
      message: message,
      timestamp: DateTime.now(),
    );
    final chatRoomId = _chatRoomId(currentUser.uid, receiverId);
    await _firestore
        .collection(FirestoreConstants.chatRoomsCollection)
        .doc(chatRoomId)
        .collection(FirestoreConstants.messagesCollection)
        .add(newMessage.toMap(recipientPublicKey: recipientPublicKey));
  }

  @override
  Stream<List<MessageModel>> getMessages({
    required String currentUserId,
    required String otherUserId,
    RSAPrivateKey? myPrivateKey,
  }) {
    final chatRoomId = _chatRoomId(currentUserId, otherUserId);
    return _firestore
        .collection(FirestoreConstants.chatRoomsCollection)
        .doc(chatRoomId)
        .collection(FirestoreConstants.messagesCollection)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => MessageModel.fromFirestore(
                  doc,
                  myPrivateKey: myPrivateKey,
                ),
              )
              .toList(),
        );
  }

  @override
  Stream<String?> getLastMessage({
    required String currentUserId,
    required String otherUserId,
  }) {
    final chatRoomId = _chatRoomId(currentUserId, otherUserId);
    return _firestore
        .collection(FirestoreConstants.chatRoomsCollection)
        .doc(chatRoomId)
        .collection(FirestoreConstants.messagesCollection)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      final data = snapshot.docs.first.data();
      // Пытаемся показать зашифрованное или открытое сообщение
      return data['ciphertext'] != null
          ? '🔒'
          : (data['message'] as String?);
    });
  }

  @override
  Future<void> savePublicKey(String userId, String encodedPublicKey) async {
    await _firestore
        .collection(FirestoreConstants.usersCollection)
        .doc(userId)
        .set({'publicKey': encodedPublicKey}, SetOptions(merge: true));
  }

  @override
  Future<String?> getPublicKey(String userId) async {
    final doc = await _firestore
        .collection(FirestoreConstants.usersCollection)
        .doc(userId)
        .get();
    return doc.data()?['publicKey'] as String?;
  }
}
