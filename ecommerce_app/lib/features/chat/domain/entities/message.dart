import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final Chat chat;
  final User sender;
  final String type;
  final String content;


  const Message({
    required this.id,
    required this.chat,
    required this.sender,
    required this.type,
    required this.content,
  
  });

  @override
  List<Object?> get props => [
        id,
        chat,
        sender,
        type,
        content,
    
      ];
}