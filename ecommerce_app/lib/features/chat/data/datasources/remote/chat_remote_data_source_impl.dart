import 'dart:convert';
import 'dart:developer';


import 'package:ecommerce_app/core/constants/api_constants.dart';
import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/features/auth/data/model/user_model.dart';
import 'package:ecommerce_app/features/chat/data/datasources/remote/chat_remote_data_source.dart';
import 'package:ecommerce_app/features/chat/data/datasources/remote/socket.dart';
import 'package:ecommerce_app/features/chat/data/models/chat_model.dart';
import 'package:ecommerce_app/features/chat/data/models/message_model.dart';
import '../../../../../core/network/http.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatRemoteDataSourceImpl extends ChatRemoteDataSource{

  final HttpClient client;
  final String _baseUrl;

  StreamSocket streamSocket = StreamSocket();

  ChatRemoteDataSourceImpl({
    required this.client,
  }) : _baseUrl = '$chatUrl/chats';
  @override
  Future<void> deleteChat(String id) async {
    try{
      final response = await client.delete('$_baseUrl/$id');

      if (response.statusCode != 200) {
        throw ServerException();
      }
      

    }catch(e){
      throw ServerException();
    }
  }

  @override
  Stream<MessageModel> getChatMessages(String id) {
    streamSocket.dispose();
    streamSocket = StreamSocket();

    client.get('$_baseUrl/$id/messages').then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> messages = jsonDecode(response.body)['data'];

        for (var message in messages) {
          streamSocket.addResponse(MessageModel.fromJson(message));
        }
      } else {
        throw ServerException();
      }
    });

    client.socket.connect();

    client.socket.onConnect((_) {
      log('Connected to the socket server');
    });

    client.socket.onDisconnect((_) {
      log('Disconnected from the socket server');
    });

    client.socket.on('message:delivered', (data) {
      MessageModel message = MessageModel.fromJson(data);
      streamSocket.addResponse(message);
    });

    client.socket.on('message:received', (data) {
      MessageModel message = MessageModel.fromJson(data);
      streamSocket.addResponse(message);
    });

    return streamSocket.getResponse;
  }

  @override
  Future<ChatModel> getOrCreateChat(UserModel receiver) async {
    try {
      final response = await client.post(_baseUrl, {
        'userId': receiver.id,
      });

      if (response.statusCode == 200) {
        return ChatModel.fromJson(jsonDecode(response.body)['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
  @override
  Future<List<ChatModel>> getUserChats() async {
    try {
      final response = await client.get(_baseUrl);

      if (response.statusCode == 200) {
        final List<dynamic> chats = jsonDecode(response.body)['data'];
        return chats.map((e) => ChatModel.fromJson(e)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  void sendMessage(String chat, String message, String type) {
    client.socket.emit('message:send', {
      'chatId': chat,
      'content': message,
      'type': type,
    });
  }
  
}