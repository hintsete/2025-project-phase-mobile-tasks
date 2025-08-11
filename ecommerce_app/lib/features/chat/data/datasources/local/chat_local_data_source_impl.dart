import 'package:ecommerce_app/features/chat/data/datasources/local/chat_local_data_source.dart';
import 'package:ecommerce_app/features/chat/data/models/chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatLocalDataSourceImpl extends ChatLocalDataSource{
  final SharedPreferences sharedPreferences;

  ChatLocalDataSourceImpl({ required this.sharedPreferences});

  @override
  Future<void> cacheChat(ChatModel product) {
    
    throw UnimplementedError();
  }

  @override
  Future<void> cacheChats(List<ChatModel> products) {
  
    throw UnimplementedError();
  }

  @override
  Future<List<ChatModel>> getChats() {
   
    throw UnimplementedError();
  }

  @override
  Future<ChatModel> getchat(String id) {
 
    throw UnimplementedError();
  }

}