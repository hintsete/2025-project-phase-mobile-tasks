import 'package:ecommerce_app/features/auth/domain/entities/authenticated_user.dart';


class AuthenticatedUserModel extends AuthenticatedUser{
  AuthenticatedUserModel({
    required super.id, 
    required super.name, 
    required super.email, 
    required super.accessToken});

    factory AuthenticatedUserModel.fromJson(Map<String,dynamic> json){
      return AuthenticatedUserModel(id: json['id'], name: json['name'], email: json['email'], accessToken: json['access-token']);
    }

    Map<String,dynamic> toJson(){
      return{
        'id':id,
        'name':name,
        'email':email,
        'access_token':accessToken,

        

      };
    }
}





