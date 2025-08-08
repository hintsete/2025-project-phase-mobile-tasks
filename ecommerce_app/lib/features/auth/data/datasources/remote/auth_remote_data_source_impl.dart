import 'dart:convert';

import 'package:ecommerce_app/core/constants/api_constants.dart';
import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:ecommerce_app/features/auth/data/model/login_model.dart';
import 'package:ecommerce_app/features/auth/data/model/signup_model.dart';
import 'package:ecommerce_app/features/auth/data/model/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final http.Client client;
  final String _baseUrl;

  AuthRemoteDataSourceImpl({required this.client})
      : _baseUrl = '$baseUrl/auth';

  @override
  Future<AccessToken> login(LoginModel loginModel) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(loginModel.toJson()), 
    );

    if (response.statusCode == 201) {
      return AccessToken.fromJson(jsonDecode(response.body)['data']);
    } else if (response.statusCode == 401) {
      throw AuthenticationException.invalidEmailAndPasswordCombination();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> signup(SignupModel signupModel) async {
    print('Sending signup request to: $_baseUrl/register');
    print('Request body: ${jsonEncode(signupModel.toJson())}');
    final response = await client.post(
      Uri.parse('$_baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(signupModel.toJson()),
    );
    print('Received response: ${response.statusCode}');
    print('Response body: ${response.body}');
    


    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body)['data']);
    } else if (response.statusCode == 409) {
      throw AuthenticationException.emailAlreadyInUse();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await client.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        
        // 'Authorization': 'Bearer TOKEN',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body)['data']);
    } else if (response.statusCode == 401) {
      throw AuthenticationException.tokenExpired();
    } else {
      throw ServerException();
    }
  }
}
