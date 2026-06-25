import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fumo/core/constants/firestore_constants.dart';
import 'package:fumo/data/models/user_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<UserModel>> searchUsers(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  SearchRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(FirestoreConstants.usersCollection);

  Future<List<UserModel>> _searchByField(String field, String query) async {
    final snapshot = await _users
        .orderBy(field)
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return const [];
    }

    final seenUids = <String>{};
    final results = <UserModel>[];

    Future<void> addResults(List<UserModel> users) async {
      for (final user in users) {
        if (seenUids.add(user.uid)) {
          results.add(user);
        }
      }
    }

    await addResults(await _searchByField('nickname', trimmedQuery));
    await addResults(await _searchByField('phone', trimmedQuery));
    await addResults(await _searchByField('email', trimmedQuery));

    return results;
  }
}
