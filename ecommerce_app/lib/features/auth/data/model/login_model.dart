import 'package:equatable/equatable.dart';

class LoginModel extends Equatable {
  final String email;
  final String password;

  LoginModel({
    required this.email,
    required this.password,
  });
  Map<String, dynamic> toJson() {
    return {
 
      'email': email,
      'password': password
    };
  }
  
  @override
 
  List<Object?> get props => [email,password];

  
}


class AccessToken extends Equatable{
  final String token;

  const AccessToken({required this.token});
  factory AccessToken.fromJson(Map<String,dynamic> json){
    // return AccessToken(token: json['access_token']);
    return AccessToken(token: json['data']['access_token']);
  }
  
  @override
 
  List<Object?> get props => [token];
}