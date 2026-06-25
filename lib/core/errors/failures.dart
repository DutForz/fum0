import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable { const Failure(this.message); final String message; @override List<Object?> get props => [message]; }
class ServerFailure extends Failure { const ServerFailure([super.message = 'Server error']); }
class AuthFailure extends Failure { const AuthFailure(super.message); }
class NicknameTakenFailure extends Failure { const NicknameTakenFailure([super.message = 'This nickname is already taken']); }
