import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/repositories/chat_repository.dart';
import 'package:fumo/domain/usecases/auth/get_auth_state.dart';
import 'package:fumo/domain/usecases/search/search_users.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required ChatRepository chatRepository,
    required SearchUsers searchUsers,
    required GetCurrentUser getCurrentUser,
  })  : _chatRepository = chatRepository,
        _searchUsers = searchUsers,
        _getCurrentUser = getCurrentUser,
        super(const HomeInitial()) {
    on<HomeStarted>(_onHomeStarted);
    on<HomeSearchQueryChanged>(_onSearchQueryChanged);
    on<HomeUsersUpdated>(_onUsersUpdated);
    on<HomeSearchCompleted>(_onSearchCompleted);
    on<HomeFailed>(_onFailed);
  }

  final ChatRepository _chatRepository;
  final SearchUsers _searchUsers;
  final GetCurrentUser _getCurrentUser;
  StreamSubscription<List<UserEntity>>? _usersSubscription;
  Timer? _debounceTimer;

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    final currentUser = _getCurrentUser();
    if (currentUser == null) {
      emit(const HomeError('Not authenticated'));
      return;
    }

    emit(const HomeLoading());
    await _usersSubscription?.cancel();
    _usersSubscription = _chatRepository.getUsersStream().listen(
      (users) => add(HomeUsersUpdated(users)),
      onError: (Object error) => add(HomeFailed(error.toString())),
    );
  }

  void _onUsersUpdated(
    HomeUsersUpdated event,
    Emitter<HomeState> emit,
  ) {
    final currentUser = _getCurrentUser();
    if (currentUser == null) {
      return;
    }

    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(users: event.users));
      return;
    }

    emit(
      HomeLoaded(
        users: event.users,
        currentUser: currentUser,
      ),
    );
  }

  Future<void> _onSearchQueryChanged(
    HomeSearchQueryChanged event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) {
      return;
    }

    final query = event.query.trim();
    if (query.isEmpty) {
      emit(
        currentState.copyWith(
          searchQuery: '',
          searchResults: const [],
          isSearching: false,
        ),
      );
      return;
    }

    emit(
      currentState.copyWith(
        searchQuery: query,
        isSearching: true,
      ),
    );

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      try {
        final results = await _searchUsers(SearchUsersParams(query: query));
        add(HomeSearchCompleted(results));
      } catch (error) {
        add(HomeFailed(error.toString()));
      }
    });
  }

  void _onSearchCompleted(
    HomeSearchCompleted event,
    Emitter<HomeState> emit,
  ) {
    final currentState = state;
    if (currentState is! HomeLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        searchResults: event.results,
        isSearching: false,
      ),
    );
  }

  void _onFailed(
    HomeFailed event,
    Emitter<HomeState> emit,
  ) {
    emit(HomeError(event.message));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _usersSubscription?.cancel();
    return super.close();
  }
}
