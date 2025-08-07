import 'package:equatable/equatable.dart';

class SignupModel extends Equatable {
  final String name;
  final String email;
  final String password;


  SignupModel({
    required this.name,
    required this.email,
    required this.password,
  });
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [name,email,password];
}