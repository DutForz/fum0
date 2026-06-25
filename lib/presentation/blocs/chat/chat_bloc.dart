import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/core/crypto/crypto_service.dart';
import 'package:fumo/domain/entities/message_entity.dart';
import 'package:fumo/domain/repositories/chat_repository.dart';
import 'package:fumo/domain/usecases/chat/delete_message.dart';
import 'package:fumo/domain/usecases/chat/get_messages.dart';
import 'package:fumo/domain/usecases/chat/send_message.dart';
import 'package:fumo/domain/usecases/chat/update_message.dart';
import 'package:pointycastle/export.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required GetMessages getMessages, required SendMessage sendMessage, required DeleteMessage deleteMessage, required UpdateMessage updateMessage, required ChatRepository chatRepository})
      : _getMessages = getMessages, _sendMessage = sendMessage, _deleteMessage = deleteMessage, _updateMessage = updateMessage, _chatRepository = chatRepository, super(const ChatInitial()) {
    on<ChatStarted>(_onChatStarted);
    on<ChatSendMessageRequested>(_onSendMessageRequested);
    on<ChatMessagesUpdated>(_onMessagesUpdated);
    on<ChatMessagesFailed>(_onMessagesFailed);
    on<ChatDeleteMessageRequested>(_onDeleteMessageRequested);
    on<ChatUpdateMessageRequested>(_onUpdateMessageRequested);
  }
  final GetMessages _getMessages;
  final SendMessage _sendMessage;
  final DeleteMessage _deleteMessage;
  final UpdateMessage _updateMessage;
  final ChatRepository _chatRepository;
  StreamSubscription<List<MessageEntity>>? _messagesSubscription;
  String? _otherUserId;
  String? _currentUserId;
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>? _myKeyPair;
  RSAPublicKey? _recipientPublicKey;

  Future<void> _onChatStarted(ChatStarted event, Emitter<ChatState> emit) async {
    await _messagesSubscription?.cancel();
    _otherUserId = event.otherUserId;
    _currentUserId = event.currentUserId;
    emit(const ChatLoading());
    await _initKeys(event.currentUserId, event.otherUserId);
    _messagesSubscription = _getMessages(GetMessagesParams(
      currentUserId: event.currentUserId,
      otherUserId: event.otherUserId,
      myPrivateKey: _myKeyPair?.privateKey,
    )).listen(
      (messages) => add(ChatMessagesUpdated(messages)),
      onError: (Object error) => add(ChatMessagesFailed(error.toString())),
    );
  }
  Future<void> _initKeys(String currentUserId, String otherUserId) async {
    try {
      _myKeyPair = CryptoService.generateRSAKeyPair();
      final encodedPublicKey = CryptoService.encodeRSAPublicKey(_myKeyPair!.publicKey);
      await _chatRepository.savePublicKey(currentUserId, encodedPublicKey);
      final encodedRecipientKey = await _chatRepository.getPublicKey(otherUserId);
      if (encodedRecipientKey != null) {
        _recipientPublicKey = CryptoService.decodeRSAPublicKey(encodedRecipientKey);
      }
    } catch (_) {}
  }
  void _onMessagesUpdated(ChatMessagesUpdated event, Emitter<ChatState> emit) {
    final currentState = state;
    if (currentState is ChatLoaded) { emit(ChatLoaded(messages: event.messages, currentUserId: currentState.currentUserId, otherUserId: currentState.otherUserId, isEncrypted: _recipientPublicKey != null)); return; }
    final otherUserId = _otherUserId;
    final currentUserId = _currentUserId;
    if (otherUserId == null || currentUserId == null) return;
    emit(ChatLoaded(messages: event.messages, currentUserId: currentUserId, otherUserId: otherUserId, isEncrypted: _recipientPublicKey != null));
  }
  void _onMessagesFailed(ChatMessagesFailed event, Emitter<ChatState> emit) { emit(ChatError(event.message)); }
  Future<void> _onSendMessageRequested(ChatSendMessageRequested event, Emitter<ChatState> emit) async {
    final otherUserId = _otherUserId;
    if (otherUserId == null || event.message.trim().isEmpty) return;
    if (_recipientPublicKey == null) { try { final encodedKey = await _chatRepository.getPublicKey(otherUserId); if (encodedKey != null) _recipientPublicKey = CryptoService.decodeRSAPublicKey(encodedKey); } catch (_) {} }
    await _sendMessage(SendMessageParams(receiverId: otherUserId, message: event.message.trim(), recipientPublicKey: _recipientPublicKey));
  }
  Future<void> _onDeleteMessageRequested(ChatDeleteMessageRequested event, Emitter<ChatState> emit) async {
    final currentUserId = _currentUserId;
    final otherUserId = _otherUserId;
    if (currentUserId == null || otherUserId == null) return;
    await _deleteMessage(DeleteMessageParams(currentUserId: currentUserId, otherUserId: otherUserId, messageId: event.messageId));
  }
  Future<void> _onUpdateMessageRequested(ChatUpdateMessageRequested event, Emitter<ChatState> emit) async {
    final currentUserId = _currentUserId;
    final otherUserId = _otherUserId;
    if (currentUserId == null || otherUserId == null) return;
    await _updateMessage(UpdateMessageParams(currentUserId: currentUserId, otherUserId: otherUserId, messageId: event.messageId, newMessage: event.newMessage));
  }
  @override Future<void> close() { _messagesSubscription?.cancel(); return super.close(); }
}
