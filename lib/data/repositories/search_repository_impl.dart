import 'package:fumo/data/datasources/search_remote_datasource.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({required SearchRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final SearchRemoteDataSource _remoteDataSource;

  @override
  Future<List<UserEntity>> searchUsers(String query) {
    return _remoteDataSource.searchUsers(query);
  }
}
