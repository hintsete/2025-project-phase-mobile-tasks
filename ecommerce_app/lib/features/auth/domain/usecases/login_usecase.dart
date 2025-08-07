import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/usecase.dart';
import 'package:ecommerce_app/features/auth/domain/entities/authenticated_user.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class LoginUsecase extends Usecase<AuthenticatedUser,LoginParams>{
  final AuthRepository repository;
  LoginUsecase(this.repository);

  @override
  Future<Either<Failure, AuthenticatedUser>> call(LoginParams params) async{

    return await repository.login(email: params.email, password: params.password);
  }
  

}

class LoginParams extends Equatable{
  final String email;
  final String password;

  LoginParams(this.email,this.password);
  
  @override

  List<Object?> get props => [email,password];
  
}