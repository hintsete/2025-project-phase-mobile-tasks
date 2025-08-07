import 'package:ecommerce_app/features/auth/data/model/login_model.dart';
import 'package:ecommerce_app/features/auth/data/model/signup_model.dart';
import 'package:ecommerce_app/features/auth/data/model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AccessToken> login(LoginModel loginModel);
  Future<UserModel> signup( SignupModel signupModel);
  Future<UserModel> getCurrentUser();
}