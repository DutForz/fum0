import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<List<Map<String, dynamic>>> searchEmail(String searchText) async {
    return (await _firestore
            .collection('Users')
            .orderBy('email')
            .startAt([searchText])
            .endAt([searchText + '\uf8ff'])
            .get())
        .docs
        .map((doc) => doc.data())
        .toList();
  }
}
