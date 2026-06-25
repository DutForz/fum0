import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/core/errors/failures.dart';
import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/usecases/auth/get_auth_state.dart';
import 'package:fumo/domain/usecases/auth/sign_in_with_email.dart';
import 'package:fumo/domain/usecases/auth/sign_out.dart';
import 'package:fumo/domain/usecases/auth/sign_up_with_email.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required GetAuthState getAuthState,
    required SignInWithEmail signInWithEmail,
    required SignUpWithEmail signUpWithEmail,
    required SignOut signOut,
  })  : _getAuthState = getAuthState,
        _signInWithEmail = signInWithEmail,
        _signUpWithEmail = signUpWithEmail,
        _signOut = signOut,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthStateChanged>(_onAuthStateChanged);
    on<AuthErrorAcknowledged>(_onErrorAcknowledged);
  }

  final GetAuthState _getAuthState;
  final SignInWithEmail _signInWithEmail;
  final SignUpWithEmail _signUpWithEmail;
  final SignOut _signOut;
  StreamSubscription<UserEntity?>? _authSubscription;

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authSubscription?.cancel();
    _authSubscription = _getAuthState(const NoParams()).listen(
      (user) => add(AuthStateChanged(user)),
    );
  }

  void _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user!));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _signInWithEmail(
        SignInParams(email: event.email, password: event.password),
      );
    } on AuthFailure catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _signUpWithEmail(
        SignUpParams(email: event.email, password: event.password),
      );
    } on AuthFailure catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _signOut(const NoParams());
    } on AuthFailure catch (e) {
      emit(AuthError(e.message));
    }
  }

  void _onErrorAcknowledged(
    AuthErrorAcknowledged event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthUnauthenticated());
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
