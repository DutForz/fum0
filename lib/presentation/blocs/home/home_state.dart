part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.users,
    required this.currentUser,
    this.searchQuery = '',
    this.searchResults = const [],
    this.isSearching = false,
  });

  final List<UserEntity> users;
  final UserEntity currentUser;
  final String searchQuery;
  final List<UserEntity> searchResults;
  final bool isSearching;

  HomeLoaded copyWith({
    List<UserEntity>? users,
    UserEntity? currentUser,
    String? searchQuery,
    List<UserEntity>? searchResults,
    bool? isSearching,
  }) {
    return HomeLoaded(
      users: users ?? this.users,
      currentUser: currentUser ?? this.currentUser,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  List<UserEntity> get displayedUsers {
    if (searchQuery.isNotEmpty) {
      return searchResults;
    }
    return users.where((user) => user.uid != currentUser.uid).toList();
  }

  @override
  List<Object?> get props => [
        users,
        currentUser,
        searchQuery,
        searchResults,
        isSearching,
      ];
}

class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
