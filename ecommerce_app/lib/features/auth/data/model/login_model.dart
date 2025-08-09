import 'package:equatable/equatable.dart';

class LoginModel extends Equatable {
  final String email;
  final String password;

  const LoginModel({
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
  // Handle case where token is at root level
  if (json['token'] != null) {
    return AccessToken(token: json['token']);
  }
  // Handle case where token is in data object
  if (json['data']?['token'] != null) {
    return AccessToken(token: json['data']['token']);
  }
  // Handle case where it's access_token instead of token
  if (json['access_token'] != null) {
    return AccessToken(token: json['access_token']);
  }
  if (json['data']?['access_token'] != null) {
    return AccessToken(token: json['data']['access_token']);
  }
  throw FormatException('Invalid token response format: $json');
}
  
  @override
 
  List<Object?> get props => [token];
}