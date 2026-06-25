import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/repositories/search_repository.dart';

class SearchUsers extends UseCase<List<UserEntity>, SearchUsersParams> {
  SearchUsers(this._repository);

  final SearchRepository _repository;

  @override
  Future<List<UserEntity>> call(SearchUsersParams params) {
    return _repository.searchUsers(params.query);
  }
}

class SearchUsersParams {
  const SearchUsersParams({required this.query});

  final String query;
}
