import 'package:ecommerce_app/features/auth/data/model/authenticated_user_model.dart';

abstract class AuthLocalDataSource {
  Future<AuthenticatedUserModel> getUser();
  Future<void> cacheUser(AuthenticatedUserModel user);
  Future<void> clear();

}