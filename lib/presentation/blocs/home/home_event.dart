part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeSearchQueryChanged extends HomeEvent {
  const HomeSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class HomeUsersUpdated extends HomeEvent {
  const HomeUsersUpdated(this.users);

  final List<UserEntity> users;

  @override
  List<Object?> get props => [users];
}

class HomeSearchCompleted extends HomeEvent {
  const HomeSearchCompleted(this.results);

  final List<UserEntity> results;

  @override
  List<Object?> get props => [results];
}

class HomeFailed extends HomeEvent {
  const HomeFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
