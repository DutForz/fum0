import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fumo/core/constants/firestore_constants.dart';
import 'package:fumo/core/errors/exceptions.dart';
import 'package:fumo/data/models/user_model.dart';
import 'package:fumo/domain/entities/registration_method.dart';

abstract class AuthRemoteDataSource {
  Stream<User?> get authStateChanges;

  User? get currentUser;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> saveUserProfile(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _auth = firebaseAuth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveUserProfile(
        UserModel(
          uid: credential.user!.uid,
          email: credential.user!.email ?? email,
          registrationMethod: RegistrationMethod.email,
        ),
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    }
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveUserProfile(
        UserModel(
          uid: credential.user!.uid,
          email: credential.user!.email ?? email,
          registrationMethod: RegistrationMethod.email,
        ),
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> saveUserProfile(UserModel user) {
    return _firestore
        .collection(FirestoreConstants.usersCollection)
        .doc(user.uid)
        .set(user.toMap(), SetOptions(merge: true));
  }
}
