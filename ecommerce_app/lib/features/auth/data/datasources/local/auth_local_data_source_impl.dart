import 'dart:convert';

import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:ecommerce_app/features/auth/data/model/authenticated_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String CACHED_USER='CACHED_USER';
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(AuthenticatedUserModel user)async {
   
    final jsonstring=json.encode(user.toJson());
    final sucess= await sharedPreferences.setString(CACHED_USER, jsonstring);
    if (!sucess){
      throw CacheException();
    }
  }

  @override
  Future<void> clear()async {
    await sharedPreferences.remove(CACHED_USER);

  
  }

  @override
  Future<AuthenticatedUserModel> getUser()async {
    final jsonString=sharedPreferences.getString(CACHED_USER);
    if(jsonString!=null){
      return AuthenticatedUserModel.fromJson(json.decode(jsonString));
    }else{
      throw CacheException();
    }


  }

}