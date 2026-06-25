part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable { const ChatEvent(); @override List<Object?> get props => []; }
class ChatStarted extends ChatEvent { const ChatStarted({required this.currentUserId, required this.otherUserId}); final String currentUserId; final String otherUserId; @override List<Object?> get props => [currentUserId, otherUserId]; }
class ChatSendMessageRequested extends ChatEvent { const ChatSendMessageRequested(this.message); final String message; @override List<Object?> get props => [message]; }
class ChatMessagesUpdated extends ChatEvent { const ChatMessagesUpdated(this.messages); final List<MessageEntity> messages; @override List<Object?> get props => [messages]; }
class ChatMessagesFailed extends ChatEvent { const ChatMessagesFailed(this.message); final String message; @override List<Object?> get props => [message]; }
class ChatDeleteMessageRequested extends ChatEvent { const ChatDeleteMessageRequested(this.messageId); final String messageId; @override List<Object?> get props => [messageId]; }
class ChatUpdateMessageRequested extends ChatEvent { const ChatUpdateMessageRequested({required this.messageId, required this.newMessage}); final String messageId; final String newMessage; @override List<Object?> get props => [messageId, newMessage]; }
