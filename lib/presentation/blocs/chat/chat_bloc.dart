import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/domain/entities/message_entity.dart';
import 'package:fumo/domain/usecases/chat/get_messages.dart';
import 'package:fumo/domain/usecases/chat/send_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required GetMessages getMessages,
    required SendMessage sendMessage,
  })  : _getMessages = getMessages,
        _sendMessage = sendMessage,
        super(const ChatInitial()) {
    on<ChatStarted>(_onChatStarted);
    on<ChatSendMessageRequested>(_onSendMessageRequested);
    on<ChatMessagesUpdated>(_onMessagesUpdated);
    on<ChatMessagesFailed>(_onMessagesFailed);
  }

  final GetMessages _getMessages;
  final SendMessage _sendMessage;
  StreamSubscription<List<MessageEntity>>? _messagesSubscription;
  String? _otherUserId;
  String? _currentUserId;

  Future<void> _onChatStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) async {
    await _messagesSubscription?.cancel();
    _otherUserId = event.otherUserId;
    _currentUserId = event.currentUserId;
    emit(const ChatLoading());

    _messagesSubscription = _getMessages(
      GetMessagesParams(
        currentUserId: event.currentUserId,
        otherUserId: event.otherUserId,
      ),
    ).listen(
      (messages) => add(ChatMessagesUpdated(messages)),
      onError: (Object error) => add(ChatMessagesFailed(error.toString())),
    );
  }

  void _onMessagesUpdated(
    ChatMessagesUpdated event,
    Emitter<ChatState> emit,
  ) {
    final currentState = state;
    if (currentState is ChatLoaded) {
      emit(
        ChatLoaded(
          messages: event.messages,
          currentUserId: currentState.currentUserId,
          otherUserId: currentState.otherUserId,
        ),
      );
      return;
    }

    final otherUserId = _otherUserId;
    final currentUserId = _currentUserId;
    if (otherUserId == null || currentUserId == null) {
      return;
    }

    emit(
      ChatLoaded(
        messages: event.messages,
        currentUserId: currentUserId,
        otherUserId: otherUserId,
      ),
    );
  }

  void _onMessagesFailed(
    ChatMessagesFailed event,
    Emitter<ChatState> emit,
  ) {
    emit(ChatError(event.message));
  }

  Future<void> _onSendMessageRequested(
    ChatSendMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    final otherUserId = _otherUserId;
    if (otherUserId == null || event.message.trim().isEmpty) {
      return;
    }

    await _sendMessage(
      SendMessageParams(
        receiverId: otherUserId,
        message: event.message.trim(),
      ),
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
