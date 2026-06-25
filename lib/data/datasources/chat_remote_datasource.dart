import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fumo/core/constants/firestore_constants.dart';
import 'package:fumo/data/models/message_model.dart';
import 'package:fumo/data/models/user_model.dart';
import 'package:pointycastle/export.dart';

abstract class ChatRemoteDataSource {
  Stream<List<UserModel>> getUsersStream();
  Future<void> sendMessage({required String receiverId, required String message, RSAPublicKey? recipientPublicKey});
  Stream<List<MessageModel>> getMessages({required String currentUserId, required String otherUserId, RSAPrivateKey? myPrivateKey});
  Stream<String?> getLastMessage({required String currentUserId, required String otherUserId});
  Future<void> savePublicKey(String userId, String encodedPublicKey);
  Future<String?> getPublicKey(String userId);
  Future<void> deleteMessage({required String currentUserId, required String otherUserId, required String messageId});
  Future<void> updateMessage({required String currentUserId, required String otherUserId, required String messageId, required String newMessage});
  Future<void> saveChatTheme({required String chatRoomId, required Map<String, dynamic> themeData});
  Stream<Map<String, dynamic>?> watchChatTheme({required String chatRoomId});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl({required FirebaseFirestore firestore, required FirebaseAuth firebaseAuth}) : _firestore = firestore, _auth = firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  String _chatRoomId(String userId, String otherUserId) { final ids = [userId, otherUserId]..sort(); return ids.join('_'); }
  @override Stream<List<UserModel>> getUsersStream() => _firestore.collection(FirestoreConstants.usersCollection).snapshots().map((snapshot) => snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
  @override Future<void> sendMessage({required String receiverId, required String message, RSAPublicKey? recipientPublicKey}) async {
    final currentUser = _auth.currentUser!;
    final newMessage = MessageModel(senderId: currentUser.uid, senderEmail: currentUser.email ?? '', receiverId: receiverId, message: message, timestamp: DateTime.now());
    await _firestore.collection(FirestoreConstants.chatRoomsCollection).doc(_chatRoomId(currentUser.uid, receiverId)).collection(FirestoreConstants.messagesCollection).add(newMessage.toMap(recipientPublicKey: recipientPublicKey));
  }
  @override Stream<List<MessageModel>> getMessages({required String currentUserId, required String otherUserId, RSAPrivateKey? myPrivateKey}) {
    return _firestore.collection(FirestoreConstants.chatRoomsCollection).doc(_chatRoomId(currentUserId, otherUserId)).collection(FirestoreConstants.messagesCollection).orderBy('timestamp', descending: false).snapshots().map((snapshot) => snapshot.docs.map((doc) => MessageModel.fromFirestore(doc, myPrivateKey: myPrivateKey)).toList());
  }
  @override Stream<String?> getLastMessage({required String currentUserId, required String otherUserId}) {
    return _firestore.collection(FirestoreConstants.chatRoomsCollection).doc(_chatRoomId(currentUserId, otherUserId)).collection(FirestoreConstants.messagesCollection).orderBy('timestamp', descending: true).limit(1).snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      final data = snapshot.docs.first.data();
      final ciphertext = data['ciphertext'] as String?;
      if (ciphertext != null && ciphertext.isNotEmpty) return '🔒 Encrypted message';
      final message = data['message'] as String?;
      if (message != null && message.startsWith('__theme__:')) return '🎨 Theme changed';
      return message;
    });
  }
  @override Future<void> savePublicKey(String userId, String encodedPublicKey) async {
    await _firestore.collection(FirestoreConstants.usersCollection).doc(userId).set({'publicKey': encodedPublicKey}, SetOptions(merge: true));
  }
  @override Future<String?> getPublicKey(String userId) async {
    final doc = await _firestore.collection(FirestoreConstants.usersCollection).doc(userId).get();
    return doc.data()?['publicKey'] as String?;
  }
  @override Future<void> deleteMessage({required String currentUserId, required String otherUserId, required String messageId}) async {
    await _firestore
        .collection(FirestoreConstants.chatRoomsCollection)
        .doc(_chatRoomId(currentUserId, otherUserId))
        .collection(FirestoreConstants.messagesCollection)
        .doc(messageId)
        .delete();
  }

  @override Future<void> updateMessage({required String currentUserId, required String otherUserId, required String messageId, required String newMessage}) async {
    await _firestore
        .collection(FirestoreConstants.chatRoomsCollection)
        .doc(_chatRoomId(currentUserId, otherUserId))
        .collection(FirestoreConstants.messagesCollection)
        .doc(messageId)
        .update({'message': newMessage, 'ciphertext': FieldValue.delete(), 'iv': FieldValue.delete(), 'encryptedKey': FieldValue.delete()});
  }
  @override Future<void> saveChatTheme({required String chatRoomId, required Map<String, dynamic> themeData}) async {
    await _firestore.collection(FirestoreConstants.chatRoomsCollection).doc(chatRoomId).set({'chatTheme': themeData}, SetOptions(merge: true));
  }

  @override Stream<Map<String, dynamic>?> watchChatTheme({required String chatRoomId}) {
    return _firestore.collection(FirestoreConstants.chatRoomsCollection).doc(chatRoomId).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return data['chatTheme'] as Map<String, dynamic>?;
    });
  }
}
