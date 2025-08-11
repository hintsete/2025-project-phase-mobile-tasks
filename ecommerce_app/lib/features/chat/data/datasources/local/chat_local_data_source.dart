import 'package:ecommerce_app/features/chat/data/models/chat_model.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheChats(List<ChatModel> products);
  Future<void> cacheChat(ChatModel product);
  Future<List<ChatModel>> getChats();
  Future<ChatModel> getchat(String id);
}