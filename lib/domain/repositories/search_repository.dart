import 'package:fumo/domain/entities/user_entity.dart';

abstract class SearchRepository {
  Future<List<UserEntity>> searchUsers(String query);
}
