import 'dart:convert';

import 'package:ecommerce_app/core/constants/api_constants.dart';
import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:ecommerce_app/features/auth/data/model/login_model.dart';
import 'package:ecommerce_app/features/auth/data/model/signup_model.dart';
import 'package:ecommerce_app/features/auth/data/model/user_model.dart';
// import 'package:http/http.dart' as http;

import '../../../../../core/network/http.dart';

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final HttpClient client;
  final String _baseUrl;

  AuthRemoteDataSourceImpl({required this.client})
      : _baseUrl = '$baseUrl/auth';

  @override
  Future<AccessToken> login(LoginModel loginModel) async {
    final response = await client.post(
      '$_baseUrl/login',
      loginModel.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      final token = json['token'] ?? json['access_token'] ?? json['data']?['token'] ?? json['data']?['access_token'] ;
      
      if (token == null) {
        throw FormatException('Token not found in response');
      }
      return AccessToken(token: token);
    } else if (response.statusCode == 401) {
      throw AuthenticationException.invalidEmailAndPasswordCombination();
    } else {
      throw ServerException();
    }
  }

  // @override
  // Future<UserModel> signup(SignupModel signupModel) async {
  //   print('Sending signup request to: $_baseUrl/register');
  //   print('Request body: ${jsonEncode(signupModel.toJson())}');
  //   final response = await client.post(
  //     Uri.parse('$_baseUrl/register'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode(signupModel.toJson()),
  //   );
  //   print('Received response: ${response.statusCode}');
  //   print('Response body: ${response.body}');
    


  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     return UserModel.fromJson(jsonDecode(response.body)['data']);
  //   } else if (response.statusCode == 409) {
  //     throw AuthenticationException.emailAlreadyInUse();
  //   } else {
  //     throw ServerException();
  //   }
  // }
  @override
  Future<UserModel> signup(SignupModel registerModel) async {
        print('Sending signup request to: $_baseUrl/register');
        print('Request body: ${jsonEncode(registerModel.toJson())}');
    final response = await client.post(
      '$_baseUrl/register',
      registerModel.toJson(),
    );
    print('Received response: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201 ) {
      return UserModel.fromJson(jsonDecode(response.body)['data']);
    } else if (response.statusCode == 409) {
      throw AuthenticationException.emailAlreadyInUse();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await client.get('$baseUrl/users/me');
    
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body)['data']);
    } else if (response.statusCode == 401) {
      throw AuthenticationException.tokenExpired();
    } else {
      throw ServerException();
    }
  }
}
