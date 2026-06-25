import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fumo/core/constants/firestore_constants.dart';
import 'package:fumo/core/errors/exceptions.dart';
import 'package:fumo/data/models/user_model.dart';
import 'package:fumo/domain/entities/registration_method.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile(String uid);
  Future<UserModel> updateProfile(UserModel profile);
  Future<String> uploadAvatar({required String uid, required String filePath});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({required FirebaseFirestore firestore, required FirebaseAuth firebaseAuth, required FirebaseStorage firebaseStorage}) : _firestore = firestore, _auth = firebaseAuth, _storage = firebaseStorage;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  CollectionReference<Map<String, dynamic>> get _users => _firestore.collection(FirestoreConstants.usersCollection);
  @override Future<UserModel> getProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists || doc.data() == null) {
      final authUser = _auth.currentUser;
      if (authUser != null && authUser.uid == uid) return UserModel(uid: authUser.uid, email: authUser.email ?? '', registrationMethod: RegistrationMethod.email);
      throw const ServerException('Profile not found');
    }
    return UserModel.fromMap(doc.data()!);
  }
  Future<void> _ensureNicknameAvailable(String nickname, String uid) async {
    final trimmed = nickname.trim();
    if (trimmed.isEmpty) return;
    final snapshot = await _users.where('nickname', isEqualTo: trimmed).limit(1).get();
    if (snapshot.docs.isEmpty) return;
    if (snapshot.docs.first.id != uid) throw const NicknameTakenException();
  }
  @override Future<UserModel> updateProfile(UserModel profile) async {
    try {
      if (profile.nickname != null && profile.nickname!.trim().isNotEmpty) await _ensureNicknameAvailable(profile.nickname!, profile.uid);
      if (profile.registrationMethod == RegistrationMethod.phone && profile.email.isNotEmpty) {
        final currentUser = _auth.currentUser;
        if (currentUser != null && currentUser.email != profile.email) await currentUser.verifyBeforeUpdateEmail(profile.email);
      }
      final updatedProfile = profile.copyWith(
        nickname: profile.nickname?.trim().isEmpty ?? true ? null : profile.nickname!.trim(),
        phone: profile.phone?.trim().isEmpty ?? true ? null : profile.phone!.trim(),
        bio: profile.bio?.trim().isEmpty ?? true ? null : profile.bio!.trim(),
        clearNickname: profile.nickname?.trim().isEmpty ?? true,
        clearPhone: profile.phone?.trim().isEmpty ?? true,
        clearBio: profile.bio?.trim().isEmpty ?? true,
      );
      await _users.doc(profile.uid).set({
        'uid': updatedProfile.uid, 'email': updatedProfile.email,
        'registrationMethod': updatedProfile.registrationMethod.toFirestoreValue(),
        'nickname': updatedProfile.nickname ?? FieldValue.delete(),
        'phone': updatedProfile.phone ?? FieldValue.delete(),
        'bio': updatedProfile.bio ?? FieldValue.delete(),
        if (updatedProfile.avatarUrl != null) 'avatarUrl': updatedProfile.avatarUrl,
      }, SetOptions(merge: true));
      return updatedProfile;
    } on FirebaseAuthException catch (e) { throw AuthException(e.code); }
    on NicknameTakenException { rethrow; }
    catch (e) { throw ServerException(e.toString()); }
  }
  @override Future<String> uploadAvatar({required String uid, required String filePath}) async {
    try {
      final file = File(filePath);
      final ref = _storage.ref().child('avatars/$uid.jpg');
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();
      await _users.doc(uid).set({'avatarUrl': downloadUrl}, SetOptions(merge: true));
      return downloadUrl;
    } catch (e) { throw ServerException(e.toString()); }
  }
}
