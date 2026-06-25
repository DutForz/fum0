part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  const ChatLoaded({
    required this.messages,
    required this.currentUserId,
    required this.otherUserId,
  });

  final List<MessageEntity> messages;
  final String currentUserId;
  final String otherUserId;

  @override
  List<Object?> get props => [messages, currentUserId, otherUserId];
}

class ChatError extends ChatState {
  const ChatError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
