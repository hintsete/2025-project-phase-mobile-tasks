import 'package:ecommerce_app/features/auth/data/model/user_model.dart';
import 'package:ecommerce_app/features/chat/data/models/chat_model.dart';
import 'package:ecommerce_app/features/chat/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id, 
    required super.chat, 
    required super.sender, 
    required super.type, 
    required super.content});

    factory MessageModel.fromJson(Map<String, dynamic> json){
      return MessageModel(
        id: json['_id'], 
        // chat: json['chat'],
        chat: ChatModel.fromJson(json['chat']), 
        // sender: json['sender'],
        sender: UserModel.fromJson(json['sender']),
        type: json['type'], 
        content: json['content']);
    }
    Map<String, dynamic> toJson(){
      return {
        'id':id,
        'chat': ChatModel.fromEntity(chat).toJson(),
        'sender':UserModel.fromEntity(sender).toJson(),
      };
    }
}